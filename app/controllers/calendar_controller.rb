class CalendarController < ApplicationController
  
  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)

    nurse_id = params[:nurse_id]
    @event_strips = Event.event_strips_for_month(@shown_month, :include => :nurse, :conditions => 'nurse_id = '+nurse_id)
  end

  def new 
  end

  def edit
  end
  
end
