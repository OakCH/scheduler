class Admin < ActiveRecord::Base
  validates_presence_of :name
=begin
  def self.add_event(start_at,end_at,nurse_id)
    nurse = Nurse.find_by_id(nurse_id)
    event = Event.create!(:name=>nurse.name,:start_at=>start_at,:end_at=>end_at,:nurse_id=>nurse_id) 
    if not event
      return false
    end
  end

  def self.delete_event(event)
    event.destroy
  end
=end

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

