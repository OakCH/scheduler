class RenameCurrentNurseIdToNurseIdInNurseBaton < ActiveRecord::Migration
  def up
    rename_column :nurse_batons, :current_nurse_id, :nurse_id
  end

  def down
    rename_column :nurse_batons, :nurse_id, :current_nurse_id
  end
end
