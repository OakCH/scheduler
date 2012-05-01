class AddPtoToEvents < ActiveRecord::Migration
  def change
    add_column :events, :pto, :boolean
  end
end
