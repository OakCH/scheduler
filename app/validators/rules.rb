class Rules < ActiveModel::Validator
  def validate(record)
    unless record.nurse.name.starts_with? 'l'
      record.errors[:name] << 'Invalid'
    end
  end
end
