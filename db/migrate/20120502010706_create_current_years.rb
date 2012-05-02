class CreateCurrentYears < ActiveRecord::Migration
  def change
    create_table :current_years do |t|
      t.integer :year

      t.timestamps
    end
  end
end
