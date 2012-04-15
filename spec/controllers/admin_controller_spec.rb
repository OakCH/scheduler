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

  describe 'when you are admin' do
    describe 'CRUD for Nurses' do
      before(:each) do
        @nurse = FactoryGirl.create(:nurse)
        @attributes => {:name=>'Nurse2',:shift=>'Days',:unit_id=>1,
          :num_weeks_off=>3,:years_worked=>5} 
      end
      describe 'CREATE' do
        it 'should call the nurse model method to create a nurse successfully' do
          post :create, @attributes
          Nurse.find_by_name(@attributes.name).should_not be_nil
        end
        it 'should redirect to index page w/ new unit & shift of new nurse' do
          post :create, @attributes
          response.should redirect_to nurse_manager_index_path, {:shift => @attributes[:shift], :unit => @attributes[:unit]}
        end
        it 'should flash a message if successfully created' do
          post :nurse_create, @attributes
          flash[:notice].should == "Nurse successfully added. Please don't forget to adjust for seniority."
        end
      end

      describe 'UPDATE' do
        it 'should call the nurse model method to update new nurse attributes successfully' do
          Nurse.stub(:find_by_id).and_return(@nurse)
          @attributes[:id]=@nurse.id
          @attributes[:name] += "duplicate" if @nurse.name == @attributes[:name]
          post :update, @attributes
          Nurse.find_by_name(@attributes[:name]).should_not be_nil
        end
        it 'should call the nurse model method and not keep the old attributes' do
          Nurse.stub(:find_by_id).and_return(@nurse)
          @attributes[:id]=@nurse.id
          @attributes[:name] += "duplicate" if @nurse.name == @attributes[:name]
          post :update, @attributes
          Nurse.find_by_name(@nurse.name).should == nil
        end
        it 'should redirect to index page w/ new unit & shift of updated nurse' do
          post :create, @attributes
          response.should redirect_to nurse_manager_index_path, {:shift => @attributes[:shift], :unit => @attributes[:unit]}
        end
        it 'should flash a message if successfully updated' do
          post :nurse_create, @attributes
          flash[:notice].should == "Nurse successfully updated. Please don't forget to adjust for seniority."
        end
      end

      describe 'DELETE' do
        it 'should call the nurse model method to delete a nurse successfully' do
          Nurse.stub(:find_by_id).and_return(@nurse)
          post :destroy, :id => @nurse.id
          Nurse.find_by_id(@attributes[:name]).should == nil
        end
        it 'should redirect to index page w/ new unit & shift of updated nurse' do
          post :create, @attributes
          response.should redirect_to nurse_manager_index_path, {:shift => @attributes[:shift], :unit => @attributes[:unit]}
        end
        it 'should flash a message if successfully updated' do
          post :nurse_create, @attributes
          flash[:notice].should == "Nurse successfully removed."
        end
     end

      describe 'ADJUST SENIORITY' do
      end
    end
  end
end
end
