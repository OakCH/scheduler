class Nurse < ActiveRecord::Base
  
  devise :database_authenticatable, :recoverable, :rememberable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
  :seniority, :shift, :unit_id, :num_weeks_off, :name, :years_worked, :unit
  
  has_many :events
  belongs_to :unit
  
  validates_uniqueness_of :seniority, :scope => [:shift, :unit_id]
  validates_uniqueness_of :email
  
  validates_presence_of :name, :shift, :unit_id, :seniority, :num_weeks_off, :email
  validates :shift, :inclusion => { :in => Unit.shifts }
  
  extend NurseBulkUploader
  
end
