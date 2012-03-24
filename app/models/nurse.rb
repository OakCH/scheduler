class Nurse < ActiveRecord::Base
  has_and_belongs_to_many :vacation_days
  belongs_to :unit

  validates_uniqueness_of :seniority, :scope => [:shift, :unit_id]
  validates_presence_of :name, :shift, :unit_id, :seniority, :num_weeks_off, :email
  validates :shift, :inclusion => { :in => Unit.shifts }
end
