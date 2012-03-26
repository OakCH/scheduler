When /^I choose "([^"]*)" to upload$/ do |file|
  attach_file('admin_upload', File.join(Rails.root, 'spec', 'fixtures', 'files', 'spreadsheets', file))
end

Given /^"(.*)" is a type of Unit$/ do |type|
  Unit.create!(:name => type)
end

Given /the following events exist/ do |events_table|
  events_table.hashes.each do |event|
    Event.create!(event)
  end
end

Given /the following nurses exist/ do |nurses_table|
  nurses_table.hashes.each do |nurse|
    Nurse.create!(nurse)
  end
end
