class RenameUnitAndShift < ActiveRecord::Migration
  def up
    rename_table :unitandshift, :unit_and_shifts
  end

  def down
    rename_table :unit_and_shift, :unitandshift
  end
end
