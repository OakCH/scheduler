class Nurse < ActiveRecord::Base
  has_many :events
  belongs_to :unit
  
  validates_uniqueness_of :seniority, :scope => [:shift, :unit_id]
  
  def self.get_by_id(id)
    return Nurse.find_by_id(id)
  end

  def self.get_nurse_ids_shift_unit_id(shift, unit_id)
    ids = Nurse.find( :all, 
                      :joins => "inner join events on events.nurse_id = nurses.id", 
                      :select => 'nurses.id', 
                      :conditions => "nurses.shift = '#{shift}' and nurses.unit_id = #{unit_id}")
    if ids.length == 0
      return nil
    end
    ids_str = '('
    ids.each do |n|
      ids_str += n.id.to_s
      ids_str += ','
    end
    return ids_str[0..-2] + ')'
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
