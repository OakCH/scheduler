class User < ActiveRecord::Base
  
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :validatable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  belongs_to :personable, :polymorphic => true, :dependent => :destroy
  
  validates_presence_of :name
  
  before_validation do
    return if (self.persisted? || self.password)
    chars = ('!'..'z').to_a
    passwd = (15..50).inject("") { |passwd, e| passwd << chars[rand(chars.length)] }
    self.password = passwd
  end
  
end
