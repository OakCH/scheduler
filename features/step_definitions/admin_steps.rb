When /^I choose "([^"]*)" to upload$/ do |file|
  attach_file('admin_upload', File.join(Rails.root, 'spec', 'fixtures', 'files', 'spreadsheets', file))
end

Given /^"(.*)" is a type of Unit$/ do |type|
  Unit.create!(:name => type)
end

Given /the following vacations exist/ do |vacations_table|
  vacations_table.hashes.each do |vacation|
    vacation[:nurse_id] = Nurse.find_by_name(vacation[:name])
    FactoryGirl.create(:event, vacation)
  end
end

Given /the following nurses exist/ do |nurses_table|
  nurses_table.hashes.each do |nurse_params|
    unit = Unit.find_by_name(nurse_params[:unit])
    unit = Unit.create!(:name => nurse_params[:unit]) if !unit
    nurse_params[:unit] = nil
    nurse_params[:unit_id] = unit.id
    FactoryGirl.create(:nurse, nurse_params)
  end
end

Then /^(?:I )?should see the vacation belonging to "([^"]*)" from "([^"]*)" to "([^"]*)"$/ do |nurse, start_date, end_date|
  parsed_start = DateTime.parse(start_date).to_time
  parsed_end = DateTime.parse(end_date).to_time
  event = Event.find_by_name_and_start_at_and_end_at(nurse, parsed_start, parsed_end)
  page.find("*[data-event-id='#{event.id}']")
end
