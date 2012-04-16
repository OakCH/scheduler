class CreateUnitAndShift < ActiveRecord::Migration
  def up
    create_table :unitandshift do |t|
      t.references :unit
      t.string :shift
      t.integer :additional_month
    end
  end

  def down
    drop_table :unitandshift
  end
end
