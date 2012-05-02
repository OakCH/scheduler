Given /the following units exist/ do |unit_table|
  unit_table.hashes.each do |unit_params|
    name = unit_params[:name]
    FactoryGirl.create(:unit, :name => name);
  end
end

Then /^the following checkboxes (should|should not) be checked: "(.*)"$/ do |should_or_not, checklist|
  checklist.split(', ').each do |name|
    step %Q{the "#{name}" checkbox #{should_or_not} be checked}
  end
end

Then /^the Admin "(.*)" (should|should not) be watching the following units: "(.*)"$/ do |name, should_or_not, units|
  admin_units = Admin.find_by_name(name).units.map(&:name)
  units.split(', ').each do |unit|
    admin_units.send(should_or_not.gsub(' ', '_'), include(unit))
  end
end
