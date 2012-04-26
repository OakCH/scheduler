class User < ActiveRecord::Base
  
  devise :invitable, :database_authenticatable, :recoverable, :rememberable
  
  validates_format_of :email, :with => /\A[^@]+@[^@]+\z/, :allow_blank => true
  
  validates_presence_of :password, :if => :not_new_record?
  validates_length_of :password, :within => 6..128, :allow_blank => true, :if => :not_new_record?
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  belongs_to :personable, :polymorphic => true, :dependent => :destroy
  
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  
  def not_new_record?
    !new_record?
  end
  
end
