class AddShiftToNurseBaton < ActiveRecord::Migration

  def up
    change_table :nurse_batons do |t|
      t.string :shift
    end
  end
 
  def down
    remove_column :nurse_batons, :shift
  end
end
