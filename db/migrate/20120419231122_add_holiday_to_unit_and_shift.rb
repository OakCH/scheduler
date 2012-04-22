class AddHolidayToUnitAndShift < ActiveRecord::Migration
  def change
    add_column :unit_and_shifts, :holiday, :integer
  end
end
