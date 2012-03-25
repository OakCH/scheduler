class AddNurseIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :nurse_id, :integer
  end
end
