class VacationDay < ActiveRecord::Base
  belongs_to :unit
  has_and_belongs_to_many :nurses
  validates_presence_of :date, :shift, :remaining_spots, :unit_id
  validates_uniqueness_of :date, :scope => [:shift, :unit_id]
  validates :shift, :inclusion => { :in => Unit.shifts }

end
