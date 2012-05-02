class CreateAdminsUnitsTable < ActiveRecord::Migration
  def up
    create_table :admins_units, :id => false do |t|
      t.integer :admin_id
      t.integer :unit_id
    end
  end

  def down
    drop_table :admins_units
  end
end
