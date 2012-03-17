require 'spec_helper'

describe NurseBulkUploader do
  
  def path_helper(spreadsheet_name)
    Rails.root.to_path + "/spec/fixtures/files/spreadsheets/#{spreadsheet_name}"
  end
  
  before(:each) do
    @unit = mock_model(Unit)
    @uploader = NurseBulkUploader::Uploader.new(@unit, 'am')
  end
  
  describe 'initialization of uploader object' do
    subject { @uploader }
    
    its (:unit) { should == @unit }
    its (:shift) { should =='am' }
    its ('parsing_errors.class') { should == Hash }
  end
  
  describe 'load spreadsheet from file' do
    
    context 'with a file format that is not xls or xlsx' do
      before { @uploader.load_from_file(path_helper("not_a_spreadsheet.txt")) }
      
      subject { @uploader.parsing_errors }
      its ([:database_changed]) { should == false }
      its ([:messages]) { should include 'File to parse was not a valid xls or xlsx' }
    end
    
    context 'with a xls' do
      before { @uploader.load_from_file(path_helper("basic_spreadsheet.xls")) }
      
      it 'should set the sheet with an Excel object' do
        @uploader.sheet.class.should == Excel
      end
      it 'should not set any parsing errors' do
        @uploader.parsing_errors[:messages].should be_empty
      end
    end
    
    context 'with a xlsx' do
      before { @uploader.load_from_file(path_helper("basic_spreadsheet.xlsx")) }

      it 'should set the sheet with an Excelx object' do
        @uploader.sheet.class.should == Excelx
      end
      it 'should not set any parsing errors' do
        @uploader.parsing_errors[:messages].should be_empty
      end
    end
    
  end
  
  describe 'checking for header row in spreadsheet' do
    
    context 'with a blank spreadsheet' do
      before(:each) do
        @uploader.sheet = Excel.new path_helper("blank.xls") # removes dependence from load_from_file
        @uploader.set_column_positions
      end
      
      it 'should set the database changed to false' do
        @uploader.parsing_errors[:database_changed].should == false
      end
      subject { @uploader.parsing_errors[:messages] }
      it 'should have an error message of missing name column' do
        should include 'Header row is missing the Name column'
      end
      it 'should have an error message of missng number of weeks off column' do
        should include 'Header row is missing the Num Weeks Off column'
      end
    end
    
    context 'where header row is missing the name column' do
      before(:each) do
        @uploader.sheet = Excel.new path_helper("missing_name_header.xls") 
        @uploader.set_column_positions
      end
      
      subject { @uploader.parsing_errors }
      its ([:database_changed]) { should == false }
      its ([:messages]) { should include 'Header row is missing the Name column' }
    end
    
    context 'where header row is missing number of vacation weeks column' do
      before(:each) do
        @uploader.sheet = Excel.new path_helper("missing_weeks_header.xls") 
        @uploader.set_column_positions
      end
      
      subject { @uploader.parsing_errors }
      its ([:database_changed]) { should == false }
      its ([:messages]) { should include 'Header row is missing the Num Weeks Off column' }
    end
    
    context 'with valid header row' do
      before(:each) do
        @uploader.sheet = Excel.new path_helper("basic_spreadsheet.xls") 
        @uploader.set_column_positions
      end
      
      it 'should set the index of each column in the cols variable' do
        @uploader.cols.should include(:name => 1, :years_worked => 2, :num_weeks_off => 3)
      end
    end
    
    context 'with an out of order valid header row' do
      before(:each) do
        @uploader.sheet = Excel.new path_helper("out_of_order.xls") 
        @uploader.set_column_positions
      end
      
      it 'should set the index of each column in the cols variable' do
        @uploader.cols.should include(:name => 1, :years_worked => 5, :num_weeks_off => 3)
      end
    end
    
  end
  
  describe 'regular expression matching of header naming' do
    ['codename', 'name'].each do |name|
      it "should match #{name} to the name column" do
        @uploader.match_name(name).should_not be_nil
      end
    end
    
    ['codname', 'namee'].each do |term|
      it "should not match #{term} to the name column" do
        @uploader.match_name(term).should be_nil
      end
    end
    
    ['number of weeks off', 'num of weeks off', 'num weeks off'].each do |term|
      it "should match #{term} to the vacation weeks column" do
        @uploader.match_num_weeks_off(term).should_not be_nil
      end
    end
    
    ['years', 'years worked'].each do |term|
      it "should match #{term} to the years worked column" do
        @uploader.match_years_worked(term).should_not be_nil
      end
    end
  end
  
  describe 'nice column name from hash symbol' do
    expected_nice_names = { :name => 'Name', :years_worked => 'Years Worked',
      :num_weeks_off => 'Num Weeks Off' }
    expected_nice_names.each do |name, nice_name|
      it "should turn #{name} into #{nice_name}" do
        @uploader.nice_col_name(name).should == nice_name
      end
    end
  end
  
  describe 'using the replace from spreadsheet method of the interface' do
    class Temp; include NurseBulkUploader; end
    before { @temp_obj = Temp.new }
    
    it 'should call the replace_from_spreadsheet method from the nested Uploader class' do
      file_path = 'fake_path'
      NurseBulkUploader::Uploader.any_instance.should_receive(:replace_from_spreadsheet)
        .with(file_path)
      @temp_obj.replace_from_spreadsheet(file_path, nil, nil)
    end
    
    it 'should set the parsing errors as an instance variable' do
      error_hash = {:database_changed => false, :errors => []}
      NurseBulkUploader::Uploader.any_instance.stub(:replace_from_spreadsheet)
      NurseBulkUploader::Uploader.any_instance.stub(:parsing_errors)
        .and_return(error_hash)
      @temp_obj.replace_from_spreadsheet(nil, nil, nil)
      @temp_obj.parsing_errors.should == error_hash
    end
  end
  
end
