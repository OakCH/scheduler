class Unit < ActiveRecord::Base
  has_many :nurses
  has_many :vacation_days
  has_many :events, :through => :nurses

  validates_uniqueness_of :name
  validates_presence_of :name

  def self.shifts
    ['Days', 'PMs', 'Nights']
  end

end
