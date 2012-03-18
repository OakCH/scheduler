class InitialSchema < ActiveRecord::Migration
  
  def up
    create_table :nurses do |t|
      t.string :name
      t.string :shift
      t.references :unit
      t.integer :seniority
      t.integer :num_weeks_off
    end
    
    create_table :admins do |t|
      t.string :name
    end
    
    create_table :nurses_vacation_days, :id => false do |t|
      t.references :nurse
      t.references :vacation_day
    end
    
    create_table :vacation_days do |t|
      t.date :date
      t.integer :remaining_spots
      t.string :shift
      t.references :unit
    end
    
    create_table :units do |t|
      t.string :name
    end
  end
  
  def down
    drop_table :nurses
    drop_table :admins
    drop_table :nurses_vacation_days
    drop_table :vacation_days
    drop_table :units
  end
  
end
