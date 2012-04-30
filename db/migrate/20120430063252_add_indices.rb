class AddIndices < ActiveRecord::Migration
  
  def change
    add_index(:events, :start_at, :order => { :start_at => :asc })
    add_index(:events, :nurse_id)
    add_index(:events, :end_at)
    add_index(:nurses, [:unit_id, :shift])
  end

end
