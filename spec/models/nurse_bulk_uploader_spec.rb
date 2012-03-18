require 'spec_helper'

describe NurseBulkUploader do
  
  def path_helper(spreadsheet_name)
    Rails.root.to_path + "/spec/fixtures/files/spreadsheets/#{spreadsheet_name}"
  end
  
  before(:each) do
    @unit = Unit.create!(:name => 'testing') # replace with factory
    @uploader = NurseBulkUploader::Uploader.new(@unit, 'am')
  end
  
  describe 'replace from spreadsheet method of the Uploader class' do
    before(:each) do
      @orig_nurse = Nurse.create!(:name => 'nurse1', :seniority => 1, :shift => 'am',
                                 :unit => @unit)
    end
    
    context 'with a file that is not xls or xlsx' do
      before { @uploader.replace_from_spreadsheet(path_helper 'not_a_spreadsheet.txt') }
      
      it 'should not delete the original nurse from the database' do
        Nurse.find_by_id(@orig_nurse.id).should == @orig_nurse
      end
      subject { @uploader.parsing_errors }
      its ([:database_changed]) { should == false }
      its ([:messages]) { should_not be_nil }
    end
    
    context 'with a file that is missing headers' do
      before { @uploader.replace_from_spreadsheet(path_helper 'missing_name_header.xls') }
      
      it 'should not delete the original nurse from the database' do
        Nurse.find_by_id(@orig_nurse.id).should == @orig_nurse
      end
      subject { @uploader.parsing_errors }
      its ([:database_changed]) { should == false }
      its ([:messages]) { should_not be_nil }
    end
    
    context 'with a file that has valid data' do
      before { @uploader.replace_from_spreadsheet(path_helper 'basic_spreadsheet.xls') }
      
      it 'should delete the original nurse from the database' do
        Nurse.find_by_id(@orig_nurse.id).should == nil
      end
      it 'should have added nurses to the database' do
        @unit.nurses.where(:shift => 'am').size.should == 3
      end
      subject { @uploader.parsing_errors }
      its ([:database_changed]) { should == true }
      its ([:messages]) { should be_empty }
    end
      
  end
  
  describe 'initialization of uploader object' do
    subject { @uploader }
    
    its (:unit) { should == @unit }
    its (:shift) { should =='am' }
    its ('parsing_errors.class') { should == Hash }
  end
  
  describe 'load spreadsheet from file' do
    
    context 'with a file format that is not xls or xlsx' do
      before { @ret = @uploader.load_from_file(path_helper("not_a_spreadsheet.txt")) }
        
      it 'should return false to indicate failure' do
        @ret.should == false
      end
      subject { @uploader.parsing_errors }
      its ([:database_changed]) { should == false }
      its ([:messages]) { should include 'File to parse was not a valid xls or xlsx' }
    end
    
    context 'with a xls' do
      before { @ret = @uploader.load_from_file(path_helper("basic_spreadsheet.xls")) }
      
      it 'should return true to indicate file was successfully loaded' do
        @ret.should == true
      end
      it 'should set the sheet with an Excel object' do
        @uploader.sheet.class.should == Excel
      end
      it 'should not set any parsing errors' do
        @uploader.parsing_errors[:messages].should be_empty
      end
    end
      
    context 'with a xlsx' do
      before { @ret = @uploader.load_from_file(path_helper("basic_spreadsheet.xlsx")) }
        
      it 'should return true to indicate file was successfully loaded' do
        @ret.should == true
      end
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
        @ret = @uploader.set_column_positions
      end
      
      it 'should return false to indicate headers could not be found' do
        @ret.should == false
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
        @ret = @uploader.set_column_positions
      end
        
      it 'should return false to indicate headers could not be found' do
        @ret.should == false
      end
      subject { @uploader.parsing_errors }
      its ([:database_changed]) { should == false }
      its ([:messages]) { should include 'Header row is missing the Name column' }
    end
    
    context 'where header row is missing number of vacation weeks column' do
      before(:each) do
        @uploader.sheet = Excel.new path_helper("missing_weeks_header.xls") 
        @ret = @uploader.set_column_positions
      end
      
      it 'should return false to indicate headers could not be found' do
        @ret.should == false
      end
      subject { @uploader.parsing_errors }
      its ([:database_changed]) { should == false }
      its ([:messages]) { should include 'Header row is missing the Num Weeks Off column' }
    end
    
    context 'with valid header row' do
      before(:each) do
        @uploader.sheet = Excel.new path_helper("basic_spreadsheet.xls") 
        @ret = @uploader.set_column_positions
      end
      
      it 'should return true to indicate required headers could be found' do
        @ret.should == true
      end
      it 'should set the index of each column in the cols variable' do
        @uploader.cols.should include(:name => 1, :years_worked => 2, :num_weeks_off => 3)
      end
    end
    
    context 'with an out of order valid header row' do
      before(:each) do
        @uploader.sheet = Excel.new path_helper("out_of_order.xls") 
        @ret = @uploader.set_column_positions
      end
      
      it 'should return true to indicate required headers could be found' do
        @ret.should == true
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
  
  describe 'destroying the original nurses' do
    it 'should set the database_changed flag to true' do
      @uploader.parsing_errors[:database_changed] == true
    end
    it 'should remove the nurses that match shift/unit' do
      rem_nurse = @unit.nurses.create!(:name => 'nurse to stay', :shift => 'pm')
      gone_nurse = @unit.nurses.create!(:name => 'nurse to remove', :shift => 'am')
      @uploader.destroy_original_nurses
      @unit.reload
      @unit.nurses.should == [rem_nurse]
    end
  end
  
  describe 'creating nurses' do
    context 'where only a header row exists' do
      before { @uploader.sheet = Excel.new path_helper('only_header.xls') }
      
      it 'should not create any nurses' do
        before_size = Nurse.all.size
        @uploader.create_nurses
        Nurse.all.size.should == before_size
      end
    end
    
    context 'with one nurse' do
      before do
        @uploader.sheet = Excel.new path_helper('one_row.xls')
        @uploader.cols = {:name => 1, :years_worked => 2, :num_weeks_off => 3}
        @uploader.create_nurses
        @nurse = @unit.nurses.find_by_shift('am')
      end
      
      it 'should only create one nurse' do
        @unit.nurses.where(:shift => 'am').size.should == 1
      end
      
      expected_vals = { :seniority => 1, :unit_id => 1, :shift => 'am', :name => 'only nurse',
        :num_weeks_off => 3, :years_worked => 1 }
      expected_vals.each do |key, val|
        it "should set the attribute #{key} to #{val}" do
          @nurse.send(key).should == val
        end
      end
    end
    
    context 'with several nurses' do
      before do
        @uploader.sheet = Excel.new path_helper('basic_spreadsheet.xls')
        @uploader.cols = {:name => 1, :years_worked => 2, :num_weeks_off => 3}
      end
      
      it 'should create a new nurse record for each row in the spreadsheet' do
        @uploader.create_nurses
        @unit.nurses.where(:shift => 'am').size.should == 3
      end
    end
    
  end
  
  describe 'setting error messages for nurses that could not be created' do
    before do
      @error_msgs = ['Failed validation, missing name', 'Failed validation, missing weeks off']
      @errors = mock(ActiveModel::Errors, :full_messages => @error_msgs)
    end
    
    it 'should place modified error message into parsing_errors' do
      expected_error1 = "Nurse in row 2: #{@error_msgs[0]}"
      expected_error2 = "Nurse in row 2: #{@error_msgs[1]}"
      @uploader.set_creation_errors(2, @errors)
      @uploader.parsing_errors[:messages].should include(expected_error1)
    end   
  end
  
  describe 'using the replace from spreadsheet method of the interface' do
    class Temp; extend NurseBulkUploader; end
    
    it 'should call the replace_from_spreadsheet method from the nested Uploader class' do
      file_path = 'fake_path'
      NurseBulkUploader::Uploader.any_instance.should_receive(:replace_from_spreadsheet).with(file_path)
      Temp.replace_from_spreadsheet(file_path, nil, nil)
    end
    
    it 'should set the parsing errors as an instance variable' do
      error_hash = { :database_changed => false, :errors => [] }
      NurseBulkUploader::Uploader.any_instance.stub(:replace_from_spreadsheet)
      NurseBulkUploader::Uploader.any_instance.stub(:parsing_errors).and_return(error_hash)
      Temp.replace_from_spreadsheet(nil, nil, nil)
      Temp.parsing_errors.should == error_hash
    end
  end
  
end
