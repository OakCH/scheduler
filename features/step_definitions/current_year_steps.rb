Given /the following current years exist/ do |year_table|
  year_table.hashes.each do |year_params|
    year = year_params[:year]
    record = CurrentYear.first
    if record
      record.year = year
      record.save
    else
      FactoryGirl.create(:current_year, :year => year)
    end
  end
end


