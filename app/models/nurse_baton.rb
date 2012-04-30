class NurseBaton < ActiveRecord::Base
  belongs_to :unit

  def current_nurse=(nurse)
    self.current_nurse_id = nurse.id
  end

  def current_nurse
    Nurse.find_by_id(current_nurse_id)
  end

end
