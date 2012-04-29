class Nurse < ActiveRecord::Base
  
  include Personable
  
  has_many :events, :dependent => :destroy
  belongs_to :unit
  
  validates_presence_of :shift, :unit_id, :num_weeks_off
  validates :shift, :inclusion => { :in => Unit.shifts }
  validates_associated :unit
  
  extend NurseBulkUploader

  include RankedModel
  ranks :nurse_order, :column => :position, :with_same => [:unit_id, :shift]

end
