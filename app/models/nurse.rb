class Nurse < ActiveRecord::Base
  
  include Personable

  has_many :events
  belongs_to :unit
  
  validates_uniqueness_of :seniority, :scope => [:shift, :unit_id]
  validates_presence_of :shift, :unit_id, :seniority, :num_weeks_off
  validates :shift, :inclusion => { :in => Unit.shifts }
  
  extend NurseBulkUploader
  
end
