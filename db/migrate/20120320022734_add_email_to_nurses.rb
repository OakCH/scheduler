class AddEmailToNurses < ActiveRecord::Migration
  def change
    add_column :nurses, :email, :string
  end
end
