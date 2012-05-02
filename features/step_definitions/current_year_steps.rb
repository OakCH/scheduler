Given /the following current years exist/ do |year_table|
  year_table.hashes.each do |year_params|
    year = year_params[:year]
    FactoryGirl.create(:current_year, :year => year)
  end
end


