Given /^the following units exist$/ do |unit_table|
  unit_table.hashes.each do |unit_params|
    name = unit_params[:name]
    FactoryGirl.create(:unit, name);
  end
end
