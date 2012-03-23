require 'spec_helper'

describe AdminController, "POST upload" do
  describe 'upon clicking next' do
    context 'with valid inputs' do
      before(:each) do
        @unit = 'Surgery'
        @shift = 'Days'
        @admin = {:unit => @unit, :shift => @shift}
      end
      
      it 'should query the units model for units' do
        Unit.should_receive(:names)
        post :upload, {:admin => @admin, :commit => 'Next'}
      end
        
      it 'should query the units model for shifts' do
        Unit.should_receive(:shifts)
        post :upload, {:admin => @admin, :commit => 'Next'}
      end
        
      it 'should assign @unit' do
        @unit_obj = Unit.create!(:name => @unit)
        Unit.stub(:find_by_name).with(@unit).and_return(@unit_obj)
        post :upload, {:admin => @admin, :commit => 'Next'}
        assigns[:unit].should == @unit_obj
      end
      
      it 'should assign @shift' do
        post :upload, {:admin => @admin, :commit => 'Next'}
        assigns[:shift].should == @shift
      end
      
      it 'should reload the page' do
        post :upload, {:admin => @admin, :commit => 'Next'}
        response.should render_template ('/admin/upload')
      end
    end
    
    context 'with invalid shift' do
      before(:each) do
        @unit = 'Surgery'
        @admin = {:unit => @unit}
      end
      
      it 'should set a flash[:notice] message if no shift' do
        @unit_obj = Unit.create!(:name=>@unit)
        Unit.stub(:find_by_name).with(@unit).and_return(@unit_obj)
        post :upload, {:admin => @admin, :commit => 'Next'}
        flash[:notice].should == ["Error: Forgot to specify shift"]
      end
      
      it 'should assign @readyToUpload to false' do
        post :upload, {:admin => @admin, :commit => 'Next'}
        assigns[:readyToUpload].should == false
      end
      
      it 'should reload the page' do
        post :upload, {:admin => @admin, :commit => 'Next'}
        response.should render_template ('/admin/upload')
      end
    end
    
    context 'with invalid unit' do
      before(:each) do
        @admin = {:shift => "PMs"}
        post :upload, {:admin => @admin, :commit => 'Next'}
      end
      
      it 'should set a flash[:notice] message if no unit' do
        flash[:notice].should == ["Error: Forgot to specify unit"]
      end
      
      it 'should assign @readyToUpload to false' do
        assigns[:readyToUpload].should == false
      end
      
      it 'should reload the page' do
        response.should render_template ('/admin/upload')
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
      Dir.glob(File.join(Rails.root, 'public', 'uploads', '**')).length.should == 1
      File.delete(Rails.root.join('public', 'uploads', 'basic_spreadsheet.xls'))
    end
    
    it 'should delete the temporary file' do
      String.any_instance.stub(:read)
      
      post :upload, {:admin => @admin, :commit => 'Upload'}
      Dir.glob(File.join(Rails.root, 'public', 'uploads', '**')).length.should == 0
    end
    
    it 'should call model method' do
      AdminController.any_instance.stub(:copyFile)
      AdminController.any_instance.stub(:deleteFile)
      
      Nurse.should_receive(:replace_from_spreadsheet).with(Rails.root.join('public', 'uploads', 'basic_spreadsheet.xls').to_path, @unit_obj, @shift)
      post :upload, {:admin => @admin, :commit => 'Upload'}
    end
    
    it 'should get all the nurses' do
      AdminController.any_instance.stub(:copyFile)
      AdminController.any_instance.stub(:deleteFile)
      
      Nurse.should_receive(:find).with(:all)
      post :upload, {:admin => @admin, :commit => 'Upload'}
    end
    
    it 'should call parsing errors' do
      AdminController.any_instance.stub(:copyFile)
      AdminController.any_instance.stub(:deleteFile)
      
      Nurse.should_receive(:parsing_errors).and_return({:messages => []})
      post :upload, {:admin => @admin, :commit => 'Upload'}
    end
    
    it 'should set flash[:notice]' do
      AdminController.any_instance.stub(:copyFile)
      Nurse.stub(:parsing_errors).and_return({:messages => ['Some Error']})
      AdminController.any_instance.stub(:deleteFile)
      
      post :upload, {:admin => @admin, :commit => 'Upload'}
      flash[:notice].should == ['Some Error']
    end
    
    it 'should render same page' do
      AdminController.any_instance.stub(:copyFile)
      AdminController.any_instance.stub(:deleteFile)
      
      post :upload, {:admin => @admin, :commit => 'Upload'}
      response.should render_template ('/admin/upload')
    end
    
    context 'with no file given' do
      it 'should set flash[:notice]' do
        AdminController.any_instance.stub(:copyFile)
        AdminController.any_instance.stub(:deleteFile)
        @admin = {:unit => @unit, :shift => @shift}
        
        post :upload, {:admin => @admin, :commit => 'Upload'}
        flash[:notice].should == ['Error: Please select a file']
      end
    end
    
  end
end