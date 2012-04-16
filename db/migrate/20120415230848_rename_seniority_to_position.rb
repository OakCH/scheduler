class RenameSeniorityToPosition < ActiveRecord::Migration
  def up
    rename_column :nurses, :seniority, :position
  end

  def down
    rename_column :nurses, :position, :seniority
  end
end
