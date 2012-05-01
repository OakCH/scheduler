class AddUnitIdToNurseBaton < ActiveRecord::Migration
  def up
    change_table :nurse_batons do |t|
      t.string :unit_id
    end
  end

  def down
    remove_column :nurse_batons, :unit_id
  end
end

