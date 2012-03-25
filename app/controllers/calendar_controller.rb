class CalendarController < ApplicationController
  
  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)

    nurse = Nurse.find(params[:nurse_id])

    ids = Nurse.get_nurse_ids_shift_unit_id(nurse.shift, nurse.unit_id)

    if ids
      @event_strips = Event.event_strips_for_month(@shown_month, :include => :nurse, :conditions => 'nurse_id in '+ ids)
    else
      @event_strips = Event.event_strips_for_month(@shown_month)
    end

  end

  def new 
    @nurse_id = params[:nurse_id]
  end

  def create
    nurse = Nurse.find(params[:nurse_id])
    event = Event.new(params[:event])
    event.name = nurse.name
    nurse.events << event
    nurse.save!
    flash[:notice] = 'You successfully scheduled your vaction'
    redirect_to :action => 'index', :nurse_id => nurse.id
  end

  def edit
    @event = Event.find(params[:id])
    @nurse_id = params[:nurse_id]
    @id = params[:id]
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes!(params[:event])
    flash[:notice] = 'You successfully scheduled your vaction'
    redirect_to :action => 'index', :nurse_id => @event.nurse_id 
  end
  
end
