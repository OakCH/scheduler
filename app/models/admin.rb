class Admin < ActiveRecord::Base
  validates_presence_of :name
  
  def self.show_events_for_month(selectors)
    unit_id = selectors[:unit_id]
    shift = selectors[:shift]
    if shift
      Unit.where(:id=>unit_id).joins({:nurses => [:events]}).where('nurses.shift = ?', shift)
    else
      return Unit.find_by_id(unit_id).events
    end
  end
end

