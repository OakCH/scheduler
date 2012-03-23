class AddYearsWorkedToNurses < ActiveRecord::Migration
  def change
    add_column :nurses, :years_worked, :integer
  end
end
