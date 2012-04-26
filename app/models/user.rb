class User < ActiveRecord::Base
  
  devise :invitable, :database_authenticatable, :recoverable, :rememberable#, :validatable (to be included when invitations are implemented)
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  belongs_to :personable, :polymorphic => true, :dependent => :destroy
  
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  
end
