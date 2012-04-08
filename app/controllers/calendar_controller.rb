class CalendarController < ApplicationController
  
  def setup_index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)
    
    yield

    # Event.event_strips_for_month will sanitize the input that has been
    # string interpolated
    @event_strips = Event.event_strips_for_month(@shown_month, :include => :nurse, :conditions => "nurses.unit_id = #{@unit_id} and nurses.shift = '#{@shift}'")
  end
  
  def index
    setup_index do
      @nurse = Nurse.find_by_id(params[:nurse_id])
      @unit_id = @nurse.unit_id
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

      if params[:shift] and params[:unit_id]
        session[:shift] = params[:shift]
        session[:unit_id] = params[:unit_id]
      end

      if session[:shift] and session[:unit_id]
        @unit_id = session[:unit_id]
        @shift = session[:shift]
      end
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @nurse_id = params[:nurse_id]
  end

  def create
    nurse = Nurse.find_by_id(params[:nurse_id])
    event = Event.new(params[:event])
    event.all_day = 1
    event.name = nurse.name
    nurse.events << event

    if not nurse.save 
      flash[:notice] = 'No vacation for you :(. Something went wrong!'
      redirect_to nurse_calendar_index_path
    else
      flash[:notice] = 'You successfully scheduled your vacation'
      redirect_to nurse_calendar_index_path(:month => event.start_at.month, :year => event.start_at.year)
    end
  end

  def edit
    @event = Event.find(params[:id])
    @nurse_id = params[:nurse_id]
    @id = params[:id]
  end

  def update
    @event = Event.find(params[:id])
    @event.all_day = 1

    if not @event.update_attributes(params[:event])
      flash[:notice] = 'Update failed'
      redirect_to nurse_calendar_index_path
    else
      flash[:notice] = 'You successfully scheduled your vacation'
      redirect_to nurse_calendar_index_path(:month => @event.start_at.month, :year => @event.start_at.year)
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:notice] = 'You successfully nuked your vacation'
    redirect_to nurse_calendar_index_path
  end

end
