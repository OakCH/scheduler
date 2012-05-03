class CurrentYear < ActiveRecord::Base
  # add code to validate only one row
  validate :one_id

  def one_id
    if CurrentYear.count > 1
      errors.add(:count, "Only one year allowed")
    end
  end
end

