class Nurse < ActiveRecord::Base
  has_many :events
  belongs_to :unit
  
  validates_uniqueness_of :seniority, :scope => [:shift, :unit_id]
  
  validates_presence_of :name, :shift, :unit_id, :seniority, :num_weeks_off, :email
  validates :shift, :inclusion => { :in => Unit.shifts }
  
  extend NurseBulkUploader
  
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

end
