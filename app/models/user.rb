class User < ActiveRecord::Base
  belongs_to :personable, :polymorphic => true, :dependent => :destroy
  
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  
end
