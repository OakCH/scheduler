class RemovePtoFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :pto
  end

  def down
    add_column :events, :pto, :boolean
  end
end
