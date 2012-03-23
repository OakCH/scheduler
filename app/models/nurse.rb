class Nurse < ActiveRecord::Base
  has_many :events
  belongs_to :unit
  
  validates_uniqueness_of :seniority, :scope => [:shift, :unit_id]
  
end
