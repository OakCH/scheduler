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

