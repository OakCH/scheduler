class Nurse < ActiveRecord::Base
  
  include Personable

  has_many :events
  belongs_to :unit
  
  validates_uniqueness_of :position, :scope => [:shift, :unit_id]
  validates_presence_of :shift, :unit_id, :position, :num_weeks_off
  validates :shift, :inclusion => { :in => Unit.shifts }
  
  extend NurseBulkUploader
  
end
