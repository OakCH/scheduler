require 'date'

class Admin < ActiveRecord::Base
  validates_presence_of :name
  
  def self.show_events_for_month(month,year,selectors)
    unit_id = selectors[:unit_id]
    shift = selectors[:shift]
    start_month = DateTime.new(year,month,1,0,0,0)
    end_month = start_month.next_month.prev_day
    if shift
      return Unit.where(:id=>unit_id).joins({:nurses => [:events]}).where('nurses.shift = ? AND 
          events.start_at > ? AND events.start_at < ?', shift, start_month, end_month)
    else
      return Unit.find_by_id(unit_id).events.where('events.start_at > ? AND events.start_at < ?',
          start_month, end_month)
    end
  end
end

