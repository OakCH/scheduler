class ChangeColumnType < ActiveRecord::Migration
  def change
    remove_column :nurse_batons, :unit_id
    add_column :nurse_batons, :unit_id, :integer
  end
  
end
