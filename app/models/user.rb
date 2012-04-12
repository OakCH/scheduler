class User < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  belongs_to :personable, :polymorphic => true, :dependent => :destroy
  
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  
  def is_admin
    return current_user.personable_type == 'Admin'
  end
  
  def admin?
    return is_admin
  end
   
end
