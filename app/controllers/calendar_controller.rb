class CalendarController < ApplicationController

  def setup_index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)

    yield

    # AS FAR AS I KNOW, under the hood, this uses the ? syntax.
    # Might not be susceptible to sql injections.
    @event_strips = Event.event_strips_for_month(@shown_month, :include => :nurse, :conditions => "nurses.unit_id = #{@unit_id} and nurses.shift = '#{@shift}'")
  end

  def index
    setup_index do
      @nurse = Nurse.find_by_id(params[:nurse_id])
      @unit_id = @nurse.unit_id
      @shift = @nurse.shift
    end
  end

  def admin_index
    setup_index do
      @shifts = Unit.shifts
      @units = Unit.find(:all)
      @shift = @shifts[0]
      @unit_id = @units[0].id

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
    event.name = nurse.name
    nurse.events << event
    nurse.save!
    flash[:notice] = 'You successfully scheduled your vacation'
    redirect_to nurse_calendar_index_path(:month => event.start_at.month, :year => event.start_at.year)
  end

  def edit
    @event = Event.find(params[:id])
    @nurse_id = params[:nurse_id]
    @id = params[:id]
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes!(params[:event])
    flash[:notice] = 'You successfully scheduled your vacation'
    redirect_to nurse_calendar_index_path(:month => @event.start_at.month, :year => @event.start_at.year)
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:notice] = 'You successfully nuked your vacation'
    redirect_to nurse_calendar_index_path
  end

end
