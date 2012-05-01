class CreateNurseBatons < ActiveRecord::Migration
  def change
    create_table :nurse_batons do |t|
      t.integer :current_nurse

      t.timestamps
    end
  end
end
