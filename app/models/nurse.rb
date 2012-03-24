class Nurse < ActiveRecord::Base
  has_many :events
  belongs_to :unit
  
  validates_uniqueness_of :seniority, :scope => [:shift, :unit_id]
  
  def self.get_by_id(id)
    return Nurse.find_by_id(id)
  end

  def add_event(start_at, end_at)
    new_event = Event.create(:name => :name, :start_at => start_at, :end_at => end_at)
    self.events << new_event
  end

  def remove_event(event)
    event.destroy!
  end

  def update_event(event, changes)
    event.update(changes)
    self.save!
  end

  def get_all_events()
    return self.events
  end

end
