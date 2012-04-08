class Unit < ActiveRecord::Base
  has_many :nurses
  has_many :vacation_days
  has_many :events, :through => :nurses
  
  validates_uniqueness_of :name
  validates_presence_of :name
  
  def self.shifts
    ['Days', 'PMs', 'Nights']
  end
  
  def self.names
    self.all.map{|unit| unit.name}
  end

  def self.is_valid_shift(shift)
    return self.shifts.include?(shift)
  end

  def self.is_valid_unit_id(unit_id)
    return Unit.find_by_id(unit_id) || unit_id == 0
  end
  
end
