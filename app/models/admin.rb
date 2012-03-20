class Admin < ActiveRecord::Base
  validates :name, :presence => true
end
