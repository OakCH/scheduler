When /^I choose "([^"]*)" to upload$/ do |file|
  attach_file('admin_upload', File.join(Rails.root, 'spec', 'fixtures', 'files', 'spreadsheets', file))
end

Given /^"(.*)" is a type of Unit$/ do |type|
  Unit.create!(:name => type)
end

Then /^(?:I )?(should|should not) see the following nurses: "([^"]*)"$/ do |should_or_not, nurses|
  nurses.split(', ').each do |nurse|
    step %Q{I #{should_or_not} see "#{nurse}"}
  end
end

Given /^the admin "([^"]*)" with email "([^"]*)" has been invited$/ do |name, email|
  admin =  FactoryGirl.create(:admin, :name => name, :email => email)
  admin.user.invite!
end

Given /^I follow the calendar for "([^"]*)"$/ do |name|
  nurse = Nurse.find_by_name(name)
  step %Q{I follow "#{nurse.id}_calendar"}
end

Given /^I press delete for "([^"]*)"$/ do |name|
  user = User.find_by_name(name).personable_id
  step %Q{I press "#{user}_delete"}
end

