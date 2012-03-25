class Admin < ActiveRecord::Base
  validates_presence_of :name
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

end

