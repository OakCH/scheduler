class NurseBaton < ActiveRecord::Base
  belongs_to :unit
  belongs_to :nurse
end
