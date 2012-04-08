class CalendarController < ApplicationController

  def setup_index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    if @month == 0 or @year == 0
      flash[:error] = "An error has happened. It's all your fault."
      redirect_to login_path
      return
    end

    @shown_month = Date.civil(@year, @month)
    
    yield

    # Event.event_strips_for_month will sanitize the input that has been
    # string interpolated
    if Unit.is_valid_shift(@shift) and Unit.is_valid_unit_id(@unit_id)
      @event_strips = Event.event_strips_for_month(@shown_month, :include => :nurse, :conditions => "nurses.unit_id = #{@unit_id} and nurses.shift = '#{@shift}'")
    else
      flash[:error] = "Error: #{@shift} and #{@unit_id} An error has happened. It's all your fault."
      redirect_to login_path
      return
    end
  end
  
  def index
    setup_index do
      @nurse = Nurse.find_by_id(params[:nurse_id])
      @unit_id = 0
      if @nurse
        @unit_id = @nurse.unit_id
      else
        flash[:error] = "An error has happend. It's all your fault."
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
          flash[:error] = "You passed an incorrect shift."
          redirect_to admin_calendar_path
          return
        end
      end

      if params[:unit_id]
        if Unit.is_valid_unit_id(params[:unit_id])
          session[:unit_id] = params[:unit_id]
        else
          flash[:error] = "You passed an incorrect unit."
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
      flash[:error] = "An error has happened. It's all your fault."
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
      flash[:error] = "An error has happened. It's all your fault."
      redirect_to login_path
      return
    end
    event = Event.new(:start_at => params[:event][:start_at], :end_at => params[:event][:end_at])
    event.all_day = 1
    event.name = nurse.name
    nurse.events << event

    if not nurse.save 
      flash[:error] = 'No vacation for you :(. Something went wrong!'
      redirect_to nurse_calendar_index_path
    else
      flash[:error] = 'You successfully scheduled your vacation'
      redirect_to nurse_calendar_index_path(:month => event.start_at.month, :year => event.start_at.year)
    end
  end

  def edit
    @event = Event.find_by_id(params[:id])
    if not @event
      flash[:error] = "An error has happened. It's all your fault."
      redirect_to login_path
      return
    end

    @nurse_id = params[:nurse_id]
    @id = params[:id]
  end

  def update
    @event = Event.find_by_id(params[:id])
    if not @event
      flash[:error] = "An error has happened. It's all your fault."
      redirect_to login_path
      return
    end

    @event.all_day = 1

    if not @event.update_attributes(:start_at => params[:event][:start_at], :end_at => params[:event][:end_at])
      flash[:error] = 'Update failed'
      redirect_to nurse_calendar_index_path
    else
      flash[:error] = 'You successfully scheduled your vacation'
      redirect_to nurse_calendar_index_path(:month => @event.start_at.month, :year => @event.start_at.year)
    end
  end

  def destroy
    @event = Event.find_by_id(params[:id])
    if not @event
      flash[:error] = "An error has happened. It's all your fault."
      redirect_to login_path
      return
    end

    if not @event.destroy
      flash[:error] = 'Something went wrong. You still get to go on vacation.'
      redirect_to nurse_calendar_index_path
    else
      flash[:error] = 'You successfully nuked your vacation'
      redirect_to nurse_calendar_index_path
    end
  end

end
