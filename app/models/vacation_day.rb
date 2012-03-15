class VacationDay < ActiveRecord::Base
  belongs_to :unit
  has_and_belongs_to_many :nurses

  validates_uniqueness_of :date, :scope => [:shift, :unit_id]
  
end
