class CreateUsersTable < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email
      t.string :name
      t.references :personable, :polymorphic => {:default => 'Nurse'}
    end
    remove_column :nurses, :name
    remove_column :nurses, :email
    remove_column :admins, :name
  end
  
  def down
    drop_table :users
  end
end
