class Unit < ActiveRecord::Base
  has_many :nurses
  has_many :vacation_days

  validates_uniqueness_of :name

  def self.shifts
    ['days', 'pm\'s', 'nights']
  end
  
end
