class Nurse < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :events
  belongs_to :unit
  
  validates_uniqueness_of :seniority, :scope => [:shift, :unit_id]
  validates_uniqueness_of :email
  
  validates_presence_of :name, :shift, :unit_id, :seniority, :num_weeks_off, :email
  validates :shift, :inclusion => { :in => Unit.shifts }
  
  extend NurseBulkUploader
  
end
