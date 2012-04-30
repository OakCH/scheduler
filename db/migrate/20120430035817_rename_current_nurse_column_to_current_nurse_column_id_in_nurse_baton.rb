class RenameCurrentNurseColumnToCurrentNurseColumnIdInNurseBaton < ActiveRecord::Migration

  change_table :nurse_batons do |t|
    t.rename :current_nurse, :current_nurse_id
  end

end
