class NurseBaton < ActiveRecord::Base
  belongs_to :unit

  def self.update_nurse(unit,shift,nurse)
    baton = NurseBaton.find_by_unit_id_and_shift(unit.id,shift)
    baton.current_nurse = nurse
    baton.save
  end

  def current_nurse=(nurse)
    self.current_nurse_id = nurse.id
  end

  def current_nurse
    Nurse.find_by_id(current_nurse_id)
  end

end
