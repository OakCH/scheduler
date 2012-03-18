class Nurse < ActiveRecord::Base
  has_and_belongs_to_many :vacation_days
  belongs_to :unit

  validates_presence_of :seniority, :name, :unit, :shift, :num_weeks_off
  validates_uniqueness_of :seniority, :scope => [:shift, :unit_id]

  extend NurseBulkUploader
  
end
