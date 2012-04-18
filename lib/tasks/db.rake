namespace :db do

  desc "Raise an error unless the RAILS_ENV is development"
  task :development_environment_only do
    raise "Task only works in development mode" unless Rails.env == 'development'
  end

  desc "Reset then seed the development database"
  task :reset_and_seed => :environment do
    Rake::Task['db:development_environment_only'].invoke
    Rake::Task['db:reset'].invoke
    preload_data
  end

  def preload_data
    unit = FactoryGirl.create(:unit, :name => 'TestUnit1')
    nurses = FactoryGirl.create_list(:nurse, 6, :unit_id => unit.id)
    FactoryGirl.create(:nurse, :shift => 'Days', :unit_id => unit.id)
    FactoryGirl.create(:admin)
    FactoryGirl.create(:event, :nurse => nurses[0], :start_at => DateTime.new(2012,5,16,0,0,0), :end_at => DateTime.new(2012,5,22,0,0,0))
    FactoryGirl.create(:event, :nurse => nurses[1], :start_at => DateTime.new(2012,5,30,0,0,0), :end_at => DateTime.new(2012,6,7,0,0,0))
    FactoryGirl.create(:event, :nurse => nurses[2], :start_at => DateTime.new(2012,4,20,0,0,0), :end_at => DateTime.new(2012,4,26,0,0,0))
    puts "Predefined data has been inserted in the database"
  end

end
