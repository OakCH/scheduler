class AddPtowithdefaultToEvents < ActiveRecord::Migration
  def change
    add_column :events, :pto, :boolean, :default => false
  end
end
