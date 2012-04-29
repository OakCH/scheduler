class CalendarController < ApplicationController
  
  before_filter :authenticate_any!
  before_filter :authenticate_admin!, :only => [:admin_index]
  
  before_filter :check_nurse_id
  before_filter :check_event_id, :only => [:show, :edit, :update, :destroy]
  
  def index
    setup_index do
      @nurse = Nurse.find_by_id(params[:nurse_id])
      @unit_id = 0
      if @nurse
        @unit_id = @nurse.unit_id
        @shift = @nurse.shift
        @cur_nurse = false
        if current_nurse == @nurse
          @cur_nurse = true
        end
      else
        flash[:error] = "An error has occurred."
        redirect_to login_path
        return
      end

      @shift = @nurse.shift
    end
    @col_names = Event.all_display_columns
  end

  def admin_index
    setup_index do
      @shifts = Unit.shifts
      @units = Unit.find(:all)
      @shift = @shifts[0]
      @unit_id = 0

      if @units.length > 0
        @unit_id = @units[0].id
      end

      if params[:shift]
        if Unit.is_valid_shift(params[:shift])
          session[:shift] = params[:shift]
        else
          flash[:error] = "Received an invalid shift: #{params[:shift]}"
          redirect_to admin_calendar_path
          return
        end
      end
      
      if params[:unit_id]
        if Unit.is_valid_unit_id(params[:unit_id])
          session[:unit_id] = params[:unit_id]
        else
          flash[:error] = "Received an invalid unit_id: #{params[:unit_id]}"
          redirect_to admin_calendar_path
          return
        end
      end
      
      if session[:shift] and session[:unit_id]
        @unit_id = session[:unit_id]
        @shift = session[:shift]
      end
    end
  end
  
  def show
    @event = Event.find_by_id(params[:id])
    if not @event
      flash[:error] = "The vacation you were looking for could not be found."
      redirect_to login_path
      return
    end
  end
  
  def new
    @nurse_id = params[:nurse_id]
  end
  
  def create
    nurse = Nurse.find_by_id(params[:nurse_id])
    if not nurse
      flash[:error] = "The nurse to create this vacation for could not be found."
      redirect_to login_path
      return
    end
    event = Event.new(:start_at => params[:event][:start_at], :end_at => params[:event][:end_at])
    event.all_day = 1
    event.name = nurse.name
    event.nurse_id = nurse.id
    
    if not event.save(:validate => (not admin_signed_in?))
      flash[:error] = "The vacation to schedule was not valid: #{event.errors.full_messages.join(' ')}"
      redirect_to nurse_calendar_index_path
    else
      flash[:notice] = 'You successfully scheduled your vacation'
      redirect_to nurse_calendar_index_path(:month => event.start_at.month, :year => event.start_at.year)
    end
  end
  
  def edit
    @nurse = Nurse.find_by_id(params[:id])
    @cur_nurse = false
    if current_nurse == @nurse
      @cur_nurse = true
    end

    @event = Event.find_by_id(params[:id])
    if not @event
      flash[:error] = "The vacation you are trying to edit could not be found."
      redirect_to login_path
      return
    end
    
    @nurse_id = @nurse.id
    @id = params[:id]
  end
  
  def update
    @event = Event.find_by_id(params[:id])
    if not @event
      flash[:error] = "The vacation you are trying to update could not be found."
      redirect_to login_path
      return
    end
    
    @event.all_day = 1
    
    @event.start_at = params[:event][:start_at]
    @event.end_at = params[:event][:end_at]
    
    if not @event.save(:validate => (not admin_signed_in?))
      flash[:error] = "The update failed for the following reasons: #{@event.errors.full_messages.join(' ')}"
      redirect_to nurse_calendar_index_path
    else
      flash[:error] = 'You successfully scheduled your vacation'
      redirect_to nurse_calendar_index_path(:month => @event.start_at.month, :year => @event.start_at.year)
    end
  end
  
  def destroy
    @event = Event.find_by_id(params[:id])
    if not @event
      flash[:error] = "The vacation you are trying to delete could not be found."
      redirect_to login_path
      return
    end
    
    if not @event.destroy
      flash[:error] = "The vacation could not be deleted."
      redirect_to nurse_calendar_index_path
    else
      flash[:notice] = "That vacation segment has been deleted."
      redirect_to nurse_calendar_index_path
    end
  end

  def admin_print
    if not session[:unit_id]
      redirect_to admin_calendar_path
      flash[:error] = "Please select a unit and filter calendars."
      return
    end
    if not session[:shift]
      redirect_to admin_calendar_path
      flash[:error] = "Please select a shift and filter calendars."
      return
    end

    @unit_id = session[:unit_id]
    @shift = session[:shift]
    @year_month = Array.new
# hard-coded => waiting for notion of time to be implemented
    months = 1..12
    months.each do |m|
      @year_month << [2012, m]
    end
    @strips = Array.new
    @year_month.each do |ym|
      cmonth = Date.civil(ym[0], ym[1])
      @strips << Event.event_strips_for_month(cmonth, 
                                              :include => :nurse, 
                                              :conditions => {"nurses.unit_id" => @unit_id, "nurses.shift" => @shift}
                                              )
    end
  end

  def print
    @nurse = Nurse.find_by_id(params[:nurse_id])
    @unit_id = @nurse.unit_id 
    @shift = @nurse.shift

    @year_month = Array.new
    @nurse.events.each do |e|
      edate = e.start_at.to_date
      date_arr = [edate.year, edate.month]
      if not @year_month.include?(date_arr)
        @year_month << date_arr
      end

      edate = e.end_at.to_date
      date_arr = [edate.year, edate.month]
      if not @year_month.include?(date_arr)
        @year_month << date_arr
      end
    end

    @strips = Array.new
    @year_month.each do |ym|
      cmonth = Date.civil(ym[0], ym[1])
      @strips << Event.event_strips_for_month(cmonth, 
                                              :include => :nurse, 
                                              :conditions => {"nurses.unit_id" => @unit_id, "nurses.shift" => @shift, "nurses.id" => @nurse.id}
                                              )
    end
  end

  private

  def setup_index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    if @month == 0 or @year == 0
      flash[:error] = "An error has occurred."
      redirect_to login_path
      return
    end

    @shown_month = Date.civil(@year, @month)

    yield

    if Unit.is_valid_shift(@shift) and Unit.is_valid_unit_id(@unit_id)
      @event_strips = Event.event_strips_for_month(@shown_month, 
                                                    :include => :nurse, 
                                                    :conditions => {"nurses.unit_id" => @unit_id, "nurses.shift" => @shift}
                                                    )
    else
      flash[:error] = "An error has happened. It's all your fault."
      redirect_to login_path
      return
    end
  end

  def check_nurse_id
    return if admin_signed_in?
    permission_denied if current_nurse != Nurse.find(params[:nurse_id])
  end

  def check_event_id
    return if admin_signed_in?
    permission_denied if current_nurse != Event.find(params[:id]).nurse
  end

end
