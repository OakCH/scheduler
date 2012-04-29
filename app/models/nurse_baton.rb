class NurseBaton < ActiveRecord::Base
  belongs_to :unit

  def self.update_nurse(unit,shift,nurse) do
    baton = NurseBaton.find_by_unit_and_shift(unit,shift).current_nurse
    baton.save
  end
end
