require 'spec_helper'

describe AdminController do

  before(:all) do
    AdminController.skip_before_filter(:authenticate_admin!)
  end

  describe "Index" do
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
          post :index, {:admin => @admin, :commit => 'Show'}
        end

        it 'should query the units model for shifts' do
          Unit.should_receive(:shifts)
          post :index, {:admin => @admin, :commit => 'Show'}
        end

        it 'should assign @unit' do
          #@unit_obj = Unit.create!(:name => @unit)
          Unit.stub(:find_by_name)#.with(@unit).and_return(@unit_obj)
          post :index, {:admin => @admin, :commit => 'Show'}
          assigns[:unit].should == @unit
        end

        it 'should assign @shift' do
          post :index, {:admin => @admin, :commit => 'Show'}
          assigns[:shift].should == @shift
        end

        it 'should reload the page' do
          post :index, {:admin => @admin, :commit => 'Show'}
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
          post :index, {:admin => @admin, :commit => 'Show'}
          flash[:error].should == ["Invalid shift"]
        end

        it 'should set a flash[:error] if the shift does not exist' do
          @unit_obj = Unit.create!(:name=>@unit)
          Unit.stub(:find_by_name).with(@unit).and_return(@unit_obj)
          @admin[:shift] = 'Fake'
          post :index, {:admin => @admin, :commit => 'Show'}
          flash[:error].should == ["Invalid shift"]
        end

        it 'should assign @readyToUpload to false' do
          post :index, {:admin => @admin, :commit => 'Show'}
          assigns[:readyToUpload].should == false
        end

        it 'should reload the page' do
          post :index, {:admin => @admin, :commit => 'Show'}
          response.should redirect_to :action => 'upload', :admin => {:unit=>@unit, :shift=>nil}
        end
      end

      context 'with invalid unit' do
        before(:each) do
          @admin = {:shift => "PMs"}
        end

        it 'should set a flash[:error] message if no unit' do
          post :index, {:admin => @admin, :commit => 'Show'}
          flash[:error].should == ["Forgot to specify unit"]
        end

        it 'should set a flash[:error] message if unit does not exist' do
          @admin[:unit] = 'Fake'
          post :index, {:admin => @admin, :commit => 'Show'}
          flash[:error].should == ['Invalid unit']
        end

        it 'should assign @readyToUpload to false' do
          post :index, {:admin => @admin, :commit => 'Show'}
          assigns[:readyToUpload].should == false
        end

        it 'should reload the page' do
          post :index, {:admin => @admin, :commit => 'Show'}
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
        post :index, {:admin => @admin, :commit => 'Upload'}
        assigns[:readyToUpload].should == true
      end

      it 'should set @file' do
        AdminController.any_instance.stub(:copyFile)
        AdminController.any_instance.stub(:deleteFile)
        post :index, {:admin => @admin, :commit => 'Upload'}
        assigns[:file].should == @basic_xls_file
      end

      it 'should create the temporary file' do
        String.any_instance.stub(:read)
        AdminController.any_instance.stub(:deleteFile)
        post :index, {:admin => @admin, :commit => 'Upload'}
        #AdminController.any_instance.should_receive(:copyFile).with(@basic_xls_file)
        File.exist?(File.join(Rails.root, 'tmp', 'basic_spreadsheet.xls')).should == true
        File.delete(Rails.root.join('tmp', 'basic_spreadsheet.xls'))
      end

      it 'should delete the temporary file' do
        String.any_instance.stub(:read)
        post :index, {:admin => @admin, :commit => 'Upload'}
        File.exist?(File.join(Rails.root, 'tmp', 'basic_spreadsheet.xls')).should == false
      end

      it 'should call model method' do
        AdminController.any_instance.stub(:copyFile)
        AdminController.any_instance.stub(:deleteFile)
        Nurse.should_receive(:replace_from_spreadsheet).with(Rails.root.join('tmp', 'basic_spreadsheet.xls').to_path, @unit_obj, @shift)
        post :index, {:admin => @admin, :commit => 'Upload'}
      end

      it 'should get the nurses within the particular unit and shift' do
        nurses = FactoryGirl.create_list(:nurse, 2)
        AdminController.any_instance.stub(:copyFile)
        AdminController.any_instance.stub(:deleteFile)
        @admin = {:unit => nurses[0].unit.name, :shift => nurses[0].shift, :upload => @basic_xls_file}
        post :index, {:admin => @admin, :commit => 'Upload'}
        assigns[:nurses].should == nurses[0, 1]
      end

      it 'should call parsing errors' do
        AdminController.any_instance.stub(:copyFile)
        AdminController.any_instance.stub(:deleteFile)

        Nurse.should_receive(:parsing_errors).and_return({:messages => []})
        post :index, {:admin => @admin, :commit => 'Upload'}
      end

      it 'should set flash[:error]' do
        AdminController.any_instance.stub(:copyFile)
        Nurse.stub(:parsing_errors).and_return({:messages => ['Some Error']})
        AdminController.any_instance.stub(:deleteFile)
        post :index, {:admin => @admin, :commit => 'Upload'}
        flash[:error].should == ['Some Error']
      end

      it 'should render same page' do
        AdminController.any_instance.stub(:copyFile)
        AdminController.any_instance.stub(:deleteFile)
        post :index, {:admin => @admin, :commit => 'Upload'}
        response.should redirect_to :action => 'upload', :admin => {:unit => @unit, :shift => @shift}
      end

      context 'with no file given' do
        it 'should set flash[:error]' do
          AdminController.any_instance.stub(:copyFile)
          AdminController.any_instance.stub(:deleteFile)
          @admin = {:unit => @unit, :shift => @shift}
          post :index, {:admin => @admin, :commit => 'Upload'}
          flash[:error].should == ['Please select a file']
        end
      end
    end
  end

  describe 'CRUD for Nurses' do
    before(:each) do
      @nurse = FactoryGirl.create(:nurse)
      @attributes = {:name=>'Nurse2',:shift=>'Days',:unit_id=>1,:num_weeks_off=>3,:years_worked=>5}
    end
    describe 'CREATE' do
      context 'Happy Path' do
        it 'should call the nurse model method to create a nurse successfully' do
          post :create, @attributes
          Nurse.find_by_name(@attributes[:name]).should_not be_nil
        end
        it 'should redirect to index page w/ new unit & shift of new nurse' do
          post :create, @attributes
          response.should redirect_to nurse_manager_index_path, {:shift => @attributes[:shift], :unit => @attributes[:unit]}
        end
        it 'should flash a message if successfully created' do
          post :create, @attributes
          flash[:notice].should == ["Nurse successfully added. Please don't forget to adjust for seniority."]
        end
      end
      context 'Sad Path' do
        it 'should not create the nurse if unit does not exist' do
          while Unit.find_by_id(@attribute[:unit])
            @attribute[:unit] += 1
          end
          post :create, @attributes
          Nurse.find_by_name(@attributes[:name]).should be_nil
        end
        it 'should not create the nurse if shift does not exist' do
          @attributes[:shift] = 'djfja3fjf823tasjflkjjg'
          @attributes[:shift] += 'BLAHBLAH' if Unit.shifts.include?(@attributes[:shift])
          post :create, @attributes
          Nurse.find_by_name(@attributes[:name]).should be_nil
        end
        it 'should not create the nurse if the email is not unique' do
          @attributes[:email] = @nurse.email
          post :create, @attributes
          Nurse.find_by_name(@attributes[:name]).should be_nil
        end
        it 'should stay on the create page' do
          @attributes[:shift] = 'djfja3fjf823tasjflkjjg'
          @attributes[:shift] += 'BLAHBLAH' if Unit.shifts.include?(@attributes[:shift])
          post :create, @attributes
          response.should render_template('create')
        end
        it 'should flash a message telling you you had invalid inputs' do
          @attributes[:shift] = 'djfja3fjf823tasjflkjjg'
          @attributes[:shift] += 'BLAHBLAH' if Unit.shifts.include?(@attributes[:shift])
          post :create, @attributes
          flash[:error].should == ['Invalid shift. Please modify and resubmit form.']
        end
      end
    end
    describe 'UPDATE' do
      context 'Happy Path' do
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
          post :update, @attributes
          response.should redirect_to nurse_manager_index_path, {:shift => @attributes[:shift], :unit => @attributes[:unit]}
        end
        it 'should flash a message if successfully updated' do
          post :update, @attributes
          flash[:notice].should == ["Nurse successfully updated. Please don't forget to adjust for seniority."]
        end
      end
      context 'Sad Path' do
        it 'should not update the nurse if unit does not exist' do
          while Unit.find_by_id(@attribute[:unit])
            @attribute[:unit] += 1
          end
          post :update, @attributes
          Nurse.find_by_name(@attributes[:name]).should be_nil
        end
        it 'should not update the nurse if shift does not exist' do
          @attributes[:shift] = 'djfja3fjf823tasjflkjjg'
          @attributes[:shift] += 'BLAHBLAH' if Unit.shifts.include?(@attributes[:shift])
          post :update, @attributes
          Nurse.find_by_name(@attributes[:name]).should be_nil
        end
        it 'should not update the nurse if the email is not unique' do
          @attributes[:email] = @nurse.email
          post :update, @attributes
          Nurse.find_by_name(@attributes[:name]).should be_nil
        end
        it 'should stay on the edit page' do
          @attributes[:shift] = 'djfja3fjf823tasjflkjjg'
          @attributes[:shift] += 'BLAHBLAH' if Unit.shifts.include?(@attributes[:shift])
          post :update, @attributes
          response.should render_template('update')
        end
        it 'should flash a message telling you you had invalid inputs' do
          @attributes[:shift] = 'djfja3fjf823tasjflkjjg'
          @attributes[:shift] += 'BLAHBLAH' if Unit.shifts.include?(@attributes[:shift])
          post :update, @attributes
          flash[:error].should == ['Invalid shift. Please modify and resubmit form.']
        end
      end
    end
    describe 'DELETE' do
      context 'Happy Path' do
        it 'should call the nurse model method to delete a nurse successfully' do
          Nurse.stub(:find_by_id).and_return(@nurse)
          post :destroy, :id => @nurse.id
          Nurse.find_by_id(@attributes[:name]).should == nil
        end
        it 'should redirect to index page w/ new unit & shift of updated nurse' do
          post :destroy, :id => @nurse.id
          response.should redirect_to nurse_manager_index_path, {:shift => @attributes[:shift], :unit => @attributes[:unit]}
        end
        it 'should flash a message if successfully updated' do
          post :destroy, :id => @nurse.id
          flash[:notice].should == ["Nurse successfully removed."]
        end
      end
      context 'Sad Path' do
        it 'should redirect to the index if nurse id does not exist' do
          id = @nurse.id 
          while Nurse.find_by_id(id)
            id += 1
          end
          post :destroy, :id => id
          response.should redirect_to nurse_manager_index_path
        end
        it 'should flash an error if the nurse id does not exist' do
          flash[:error].should == ["Nurse id does not exist. Did not remove."]
        end
      end
    end
  end
end
