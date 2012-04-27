Given /the following vacations exist/ do |vacations_table|
  vacations_table.hashes.each do |vacation|
    vacation[:nurse] = Nurse.find_by_name(vacation[:name])
    FactoryGirl.create(:event, vacation)
  end
end

Given /^I enter in the following vacations$/ do |vacations_table|
   vacations_table.hashes.each do |vacation|
    vacation[:nurse] = Nurse.find_by_name(vacation[:name])
    FactoryGirl.create(:event, vacation)
  end
end

Given /the following nurses exist(?: in this seniority order)?/ do |nurses_table|
  nurses_table.hashes.each do |nurse_params|
    if nurse_params[:unit]
      unit = Unit.find_by_name(nurse_params[:unit])
      unit = Unit.create!(:name => nurse_params[:unit]) if !unit
      nurse_params[:unit] = nil
      nurse_params[:unit_id] = unit.id
    end
    FactoryGirl.create(:nurse, nurse_params)
  end
end

Given /the following admins exist/ do |admin_table|
  admin_table.hashes.each do |admin_params|
    FactoryGirl.create(:admin, admin_params)
  end
end

Then /^(?:I )?(should|should not) see the vacation belonging to "([^"]*)" from "([^"]*)" to "([^"]*)"$/ do |should_or_not, nurse, start_date, end_date|
  event = event_finder(nurse, start_date, end_date)
  #page.find("*[data-event-id='#{event.id}']")
  page.send should_or_not.gsub(' ', '_'), have_css("*[data-event-id='#{event.id}']")
end

def event_finder(nurse, start_date, end_date)
  parsed_start = DateTime.parse(start_date).to_time
  parsed_end = (DateTime.parse(end_date) + 1).to_time - 1
  Event.find_by_name_and_start_at_and_end_at(nurse, parsed_start, parsed_end)
end

def event_all_finder(nurse)
  Event.find_all_by_name(nurse)
end

Then /^(?:I )?(should|should not) see vacations belonging to "([^"]*)"$/ do |should_or_not, nurse|
  events = event_all_finder(nurse)
  events.each do |event|
    page.send should_or_not.gsub(' ', '_'), have_css("*[data-event-id='#{event.id}']")
  end
end
  
