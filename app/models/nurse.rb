class Nurse < ActiveRecord::Base
  has_many :events
  belongs_to :unit

  validates_uniqueness_of :seniority, :scope => [:shift, :unit_id]
  validates_presence_of :name, :shift, :unit_id, :seniority, :num_weeks_off, :email
  validates :shift, :inclusion => { :in => Unit.shifts }
end
