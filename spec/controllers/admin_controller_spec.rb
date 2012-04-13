require 'spec_helper'

describe AdminController do

  before(:all) do
    AdminController.skip_before_filter(:authenticate_admin!)
  end
  
  describe "Upload" do
    describe 'upon clicking Show' do
      context 'with valid inputs' do
        before(:each) do
          @unit = 'Surgery'
          @shift = 'Days'
          @admin = {:unit => @unit, :shift => @shift}
          Unit.stub(:shifts).and_return(['Days'])
        end
        
        it 'should query the units model for units' do
          Unit.should_receive(:names)
          post :upload, {:admin => @admin, :commit => 'Show'}
        end
        
        it 'should query the units model for shifts' do
          Unit.should_receive(:shifts)
          post :upload, {:admin => @admin, :commit => 'Show'}
        end
        
        it 'should assign @unit' do
          #@unit_obj = Unit.create!(:name => @unit)
          Unit.stub(:find_by_name)#.with(@unit).and_return(@unit_obj)
          post :upload, {:admin => @admin, :commit => 'Show'}
          assigns[:unit].should == @unit
        end
        
        it 'should assign @shift' do
          post :upload, {:admin => @admin, :commit => 'Show'}
          assigns[:shift].should == @shift
        end
        
        it 'should reload the page' do
          post :upload, {:admin => @admin, :commit => 'Show'}
          response.should redirect_to :action => 'upload', :admin => @admin
        end
      end
      
      context 'with invalid shift' do
        before(:each) do
          @unit = 'Surgery'
          @admin = {:unit => @unit}
        end
        
        it 'should set a flash[:error] message if no shift' do
          @unit_obj = Unit.create!(:name=>@unit)
          Unit.stub(:find_by_name).with(@unit).and_return(@unit_obj)
          post :upload, {:admin => @admin, :commit => 'Show'}
          flash[:error].should == ["Invalid shift"]
        end
        
        it 'should set a flash[:error] if the shift does not exist' do
          @unit_obj = Unit.create!(:name=>@unit)
          Unit.stub(:find_by_name).with(@unit).and_return(@unit_obj)
          @admin[:shift] = 'Fake'
          post :upload, {:admin => @admin, :commit => 'Show'}
          flash[:error].should == ["Invalid shift"]
        end
        
        it 'should assign @readyToUpload to false' do
          post :upload, {:admin => @admin, :commit => 'Show'}
          assigns[:readyToUpload].should == false
        end
        
        it 'should reload the page' do
          post :upload, {:admin => @admin, :commit => 'Show'}
          response.should redirect_to :action => 'upload', :admin => {:unit=>@unit, :shift=>nil}
        end
      end
      
      context 'with invalid unit' do
        before(:each) do
          @admin = {:shift => "PMs"}
        end
        
        it 'should set a flash[:error] message if no unit' do
          post :upload, {:admin => @admin, :commit => 'Show'}
          flash[:error].should == ["Forgot to specify unit"]
        end
        
        it 'should set a flash[:error] message if unit does not exist' do
          @admin[:unit] = 'Fake'
          post :upload, {:admin => @admin, :commit => 'Show'}
          flash[:error].should == ['Invalid unit']
        end
        
        it 'should assign @readyToUpload to false' do
          post :upload, {:admin => @admin, :commit => 'Show'}
          assigns[:readyToUpload].should == false
        end
        
        it 'should reload the page' do
          post :upload, {:admin => @admin, :commit => 'Show'}
          response.should redirect_to :action => 'upload', :admin => {:shift => "PMs", :unit => nil}
        end
      end
      
    end
    
    describe 'upon clicking upload' do
      before (:each) do
        @unit = 'Surgery'
        @unit_obj = Unit.create!(:name => @unit)
        @shift = 'Days'
        @basic_xls_file = path_helper 'basic_spreadsheet.xls'
        @admin = {:unit => @unit, :shift => @shift, :upload => @basic_xls_file}
        
        String.any_instance.stub(:original_filename).and_return('basic_spreadsheet.xls')
        Nurse.stub(:replace_from_spreadsheet)
        Nurse.stub(:parsing_errors).and_return({:messages => []})
      end
      
      def path_helper(spreadsheet_name)
        Rails.root.to_path + "/spec/fixtures/files/spreadsheets/#{spreadsheet_name}"
      end
      
      it 'should set @readyToUpload to true' do
        AdminController.any_instance.stub(:copyFile)
        AdminController.any_instance.stub(:deleteFile)
        
        post :upload, {:admin => @admin, :commit => 'Upload'}
        assigns[:readyToUpload].should == true
      end
      
      it 'should set @file' do
        AdminController.any_instance.stub(:copyFile)
        AdminController.any_instance.stub(:deleteFile)
        
        post :upload, {:admin => @admin, :commit => 'Upload'}
        assigns[:file].should == @basic_xls_file
      end
      
      it 'should create the temporary file' do
        String.any_instance.stub(:read)
        AdminController.any_instance.stub(:deleteFile)
        
        post :upload, {:admin => @admin, :commit => 'Upload'}
        #AdminController.any_instance.should_receive(:copyFile).with(@basic_xls_file)
        File.exist?(File.join(Rails.root, 'tmp', 'basic_spreadsheet.xls')).should == true
        File.delete(Rails.root.join('tmp', 'basic_spreadsheet.xls'))
        
      end
      
      it 'should delete the temporary file' do
        String.any_instance.stub(:read)
        
        post :upload, {:admin => @admin, :commit => 'Upload'}
        File.exist?(File.join(Rails.root, 'tmp', 'basic_spreadsheet.xls')).should == false
      end
      
      it 'should call model method' do
        AdminController.any_instance.stub(:copyFile)
        AdminController.any_instance.stub(:deleteFile)
        
        Nurse.should_receive(:replace_from_spreadsheet).with(Rails.root.join('tmp', 'basic_spreadsheet.xls').to_path, @unit_obj, @shift)
        post :upload, {:admin => @admin, :commit => 'Upload'}
      end
      
      it 'should get the nurses within the particular unit and shift' do
        nurses = FactoryGirl.create_list(:nurse, 2)
        AdminController.any_instance.stub(:copyFile)
        AdminController.any_instance.stub(:deleteFile)
        @admin = {:unit => nurses[0].unit.name, :shift => nurses[0].shift, :upload => @basic_xls_file}
        post :upload, {:admin => @admin, :commit => 'Upload'}
        assigns[:nurses].should == nurses[0, 1]
      end
      
      it 'should call parsing errors' do
        AdminController.any_instance.stub(:copyFile)
        AdminController.any_instance.stub(:deleteFile)
        
        Nurse.should_receive(:parsing_errors).and_return({:messages => []})
        post :upload, {:admin => @admin, :commit => 'Upload'}
      end
      
      it 'should set flash[:error]' do
        AdminController.any_instance.stub(:copyFile)
        Nurse.stub(:parsing_errors).and_return({:messages => ['Some Error']})
        AdminController.any_instance.stub(:deleteFile)
        
        post :upload, {:admin => @admin, :commit => 'Upload'}
        flash[:error].should == ['Some Error']
      end
      
      it 'should render same page' do
        AdminController.any_instance.stub(:copyFile)
        AdminController.any_instance.stub(:deleteFile)
        
        post :upload, {:admin => @admin, :commit => 'Upload'}
        response.should redirect_to :action => 'upload', :admin => {:unit => @unit, :shift => @shift}
      end
      
      context 'with no file given' do
        it 'should set flash[:error]' do
          AdminController.any_instance.stub(:copyFile)
          AdminController.any_instance.stub(:deleteFile)
          @admin = {:unit => @unit, :shift => @shift}
          
          post :upload, {:admin => @admin, :commit => 'Upload'}
          flash[:error].should == ['Please select a file']
        end
      end
      
    end
  end
  
  describe 'rules' do
    context 'with 60 accrued vacation weeks' do
      before(:each) do
        @unit = FactoryGirl.create(:unit, :name => 'Surgery')
        FactoryGirl.create_list(:nurse, 6, :unit => @unit, :shift => 'Days')
      end
      context 'with valid input' do
        before(:each) do
          @shift = 'Days'
          @admin = {:unit => @unit.name, :shift => @shift}
        end
        it 'should set @readyToShow to true' do
          post :rules, {:admin => @admin, :commit => 'Next'}
          assigns[:readyToShow].should == true
        end
        it 'should set @num_months to 2' do
          post :rules, {:admin => @admin, :commit => 'Next'}
          assigns[:num_months].should == 2
        end
        it 'should redirect to rules page' do
          post :rules, {:admin => @admin, :commit => 'Next'}
          response.should redirect_to :action => :rules, :admin => @admin
        end
      end
      context 'with invalid input' do
        it 'should assign @readyToShow to false' do
          @admin = {:unit => @unit.name}
          post :rules, {:admin => @admin, :commit => 'Next'}
          assigns[:readyToShow].should == false
        end
        it 'should redirect to rules page' do
          @admin = {:unit => @unit.name, :shift => 'Not a shift'}
          post :rules, {:admin => @admin, :commit => 'Next'}
          response.should redirect_to :action => :rules, :admin => {:unit => @unit.name, :shift => nil}
        end
      end
    end
    
    describe 'after selecting the month' do
       it 'should add the month into the db'
    end
  end
end
