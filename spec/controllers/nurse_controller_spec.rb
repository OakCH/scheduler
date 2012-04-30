require 'spec_helper'

describe NurseController do

  before(:all) do
    NurseController.skip_before_filter(:authenticate_admin!)
    NurseController.skip_before_filter(:authenticate_any!)
    NurseController.skip_before_filter(:check_nurse_id)
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
          response.should redirect_to nurse_manager_index_path(:admin=> @admin)
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
          response.should redirect_to nurse_manager_index_path(:admin=> {:unit=>@unit, :shift=>nil})
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
          response.should redirect_to nurse_manager_index_path(:admin=> {:unit=>nil, :shift=>"PMs"})
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
        NurseController.any_instance.stub(:copyFile)
        NurseController.any_instance.stub(:deleteFile)
        get :index, {:admin => @admin, :commit => 'Upload'}
        assigns[:readyToUpload].should == true
      end

      it 'should set @file' do
        NurseController.any_instance.stub(:copyFile)
        NurseController.any_instance.stub(:deleteFile)
        post :upload, {:admin => @admin, :commit => 'Upload'}
        assigns[:file].should == @basic_xls_file
      end

      it 'should create the temporary file' do
        String.any_instance.stub(:read)
        NurseController.any_instance.stub(:deleteFile)
        post :upload, {:admin => @admin, :commit => 'Upload'}
        #NurseController.any_instance.should_receive(:copyFile).with(@basic_xls_file)
        File.exist?(File.join(Rails.root, 'tmp', 'basic_spreadsheet.xls')).should == true
        File.delete(Rails.root.join('tmp', 'basic_spreadsheet.xls'))
      end

      it 'should delete the temporary file' do
        String.any_instance.stub(:read)
        post :upload, {:admin => @admin, :commit => 'Upload'}
        File.exist?(File.join(Rails.root, 'tmp', 'basic_spreadsheet.xls')).should == false
      end

      it 'should call model method' do
        NurseController.any_instance.stub(:copyFile)
        NurseController.any_instance.stub(:deleteFile)
        Nurse.should_receive(:replace_from_spreadsheet).with(Rails.root.join('tmp', 'basic_spreadsheet.xls').to_path, @unit_obj, @shift)
        post :upload, {:admin => @admin, :commit => 'Upload'}
      end

      it 'should get the nurses within the particular unit and shift' do
        nurses = FactoryGirl.create_list(:nurse, 2)
        @admin = {:unit => nurses[0].unit.name, :shift => nurses[0].shift, :upload => @basic_xls_file}
        get :index, {:admin => @admin, :commit => 'Commit'}
        assigns[:nurses].should == nurses[0, 1]
      end

      it 'should call parsing errors' do
        NurseController.any_instance.stub(:copyFile)
        NurseController.any_instance.stub(:deleteFile)

        Nurse.should_receive(:parsing_errors).and_return({:messages => []})
        post :upload, {:admin => @admin, :commit => 'Upload'}
      end

      it 'should set flash[:error]' do
        NurseController.any_instance.stub(:copyFile)
        Nurse.stub(:parsing_errors).and_return({:messages => ['Some Error']})
        NurseController.any_instance.stub(:deleteFile)
        post :upload, {:admin => @admin, :commit => 'Upload'}
        flash[:error].should == ['Some Error']
      end

      it 'should render same page' do
        NurseController.any_instance.stub(:copyFile)
        NurseController.any_instance.stub(:deleteFile)
        post :upload, {:admin => @admin, :commit => 'Upload'}
        response.should redirect_to nurse_manager_index_path(:admin => {:unit => @unit, :shift => @shift})
      end

      context 'with no file given' do
        it 'should set flash[:error]' do
          NurseController.any_instance.stub(:copyFile)
          NurseController.any_instance.stub(:deleteFile)
          @admin = {:unit => @unit, :shift => @shift}
          post :upload, {:admin => @admin, :commit => 'Upload'}
          flash[:error].should == ['Please select a file']
        end
      end
    end
  end

  describe 'CRUD for Nurses' do
    before(:each) do
      @unit = FactoryGirl.create(:unit)
      @nurse = FactoryGirl.create(:nurse, :unit_id => @unit.id)
      @attributes_hash = {:name=>'Nurse2',:email => 'nurse2email@email.com', :shift=>'Days',:unit=>@unit.name,:num_weeks_off=>3,:years_worked=>5}
      @attributes = {:nurse=>@attributes_hash}
    end
    describe 'CREATE' do
      context 'Happy Path' do
        it 'should call the nurse model method to create a nurse successfully' do
          post :create, @attributes
          @unit.should_not be_nil
          Nurse.find_by_name(@attributes[:nurse][:name]).should_not be_nil
        end
        it 'should redirect to index page w/ new unit & shift of new nurse' do
          post :create, @attributes
          response.should redirect_to nurse_manager_index_path(:admin=>{:shift => @attributes[:nurse][:shift], :unit => @attributes[:nurse][:unit]})
        end
        it 'should flash a message if successfully created' do
          post :create, @attributes
          flash[:notice].should == "#{@attributes[:nurse][:name]} was successfully added."
        end
      end
      context 'Sad Path' do
        it 'should not create the nurse if unit does not exist' do
          @unit.name += '325DUPLICATECOPY'
          @attributes[:nurse][:unit] = @unit.name
          post :create, @attributes
          Nurse.find_by_name(@attributes[:nurse][:name]).should be_nil
        end
        it 'should not create the nurse if shift does not exist' do
          @attributes[:nurse][:shift] = 'djfja3fjf823tasjflkjjg'
          post :create, @attributes
          Nurse.find_by_name(@attributes[:nurse][:name]).should be_nil
        end
        it 'should not create the nurse if the email is not unique' do
          @attributes[:nurse][:email] = @nurse.email
          post :create, @attributes
          Nurse.find_by_name(@attributes[:nurse][:name]).should be_nil
        end
        it 'should stay on the create page' do
          @attributes[:nurse][:shift] = 'djfja3fjf823tasjflkjjg'
          post :create, @attributes
          response.should render_template('new')
        end
        it 'should flash a message telling you you had invalid inputs' do
          @attributes[:nurse][:shift] = 'djfja3fjf823tasjflkjjg'
          post :create, @attributes
          flash[:error].should_not be_empty
        end
      end
    end
    describe 'UPDATE' do
      context 'Happy Path' do
        it 'should call the nurse model method to update new nurse attributes successfully' do
          Nurse.stub(:find_by_id).and_return(@nurse)
          @attributes[:nurse][:id]=@nurse.id
          @attributes[:nurse][:name] += "duplicate"
          @attributes[:nurse].should_not be_nil
          post :update, :id => @attributes[:nurse][:id], :nurse => @attributes[:nurse]
          Nurse.find_by_name(@attributes[:nurse][:name]).should_not be_nil
        end
        it 'should make sure it updated a nurse' do
          Nurse.stub(:find_by_id).and_return(@nurse)
          @attributes[:nurse][:id]=@nurse.id
          @attributes[:nurse][:name] += "duplicate" if @nurse.name == @attributes[:nurse][:name]
          post :update, :id => @attributes[:nurse][:id], :nurse => @attributes[:nurse]
          Nurse.find_by_name(@attributes[:nurse][:name]).should_not be_nil
        end
        it 'should call the nurse model method and not keep the old attributes' do
          Nurse.stub(:find_by_id).and_return(@nurse)
          @attributes[:nurse][:id]=@nurse.id
          @attributes[:nurse][:name] += "duplicate" if @nurse.name == @attributes[:nurse][:name]
          post :update, :id => @attributes[:nurse][:id], :nurse => @attributes[:nurse]
          Nurse.find_by_name(@nurse.name).should == nil
        end
        it 'should redirect to index page w/ new unit & shift of updated nurse' do
          @attributes[:nurse][:id]=@nurse.id
          post :update, :id => @attributes[:nurse][:id], :nurse => @attributes[:nurse]
          response.should redirect_to nurse_manager_index_path(:admin=>{:shift => @attributes[:nurse][:shift], :unit => @attributes[:nurse][:unit]})
        end
        it 'should flash a message if successfully updated' do
          @attributes[:nurse][:id]=@nurse.id
          post :update, :id => @attributes[:nurse][:id], :nurse => @attributes[:nurse]
          flash[:notice].should == "#{@attributes[:nurse][:name]} successfully updated."
        end
      end
      context 'Sad Path' do
        it 'should not update the nurse if unit does not exist' do
          @attributes[:nurse][:unit] += 'DUPLICATECOPYDOESNTEXIST'
          @attributes[:nurse][:id]=@nurse.id
          post :update, :id => @attributes[:nurse][:id], :nurse => @attributes[:nurse]
          Nurse.find_by_name(@nurse.name).unit_id.should == @nurse.unit_id
        end
        it 'should not update the nurse if shift does not exist' do
          @attributes[:nurse][:shift] = 'djfja3fjf823tasjflkjjg'
          @attributes[:nurse][:id]=@nurse.id
          post :update, :id => @attributes[:nurse][:id], :nurse => @attributes[:nurse]
          Nurse.find_by_name(@attributes[:nurse][:name]).should be_nil
        end
        it 'should not update the nurse if the email is not unique' do
          new_nurse = FactoryGirl.create(:nurse, :email => 'tester@test.com')
          @attributes[:nurse][:email] = @nurse.email
          @attributes[:nurse][:id] = new_nurse.id
          post :update, :id => @attributes[:nurse][:id], :nurse => @attributes[:nurse]
          Nurse.find_by_name(@attributes[:nurse][:name]).should be_nil
        end
        it 'should stay on the edit page' do
          @attributes[:nurse][:shift] = 'djfja3fjf823tasjflkjjg'
          @attributes[:nurse][:shift] += 'BLAHBLAH' if Unit.shifts.include?(@attributes[:nurse][:shift])
          @attributes[:nurse][:id]=@nurse.id
          post :update, :id => @attributes[:nurse][:id], :nurse => @attributes[:nurse]
          response.should render_template('edit')
        end
        it 'should flash a message telling you you had invalid inputs' do
          @attributes[:nurse][:shift] = 'djfja3fjf823tasjflkjjg'
          @attributes[:nurse][:id]=@nurse.id
          post :update, :id => @attributes[:nurse][:id], :nurse => @attributes[:nurse]
          flash[:error].should_not be_empty
        end
      end
    end
    describe 'DELETE' do
      context 'Happy Path' do
        it 'should call the nurse model method to delete a nurse successfully' do
          Nurse.stub(:find_by_id).and_return(@nurse)
          post :destroy, :id => @nurse.id
          Nurse.find_by_name(@attributes[:nurse][:name]).should == nil
        end
        it 'should redirect to index page w/ new unit & shift of updated nurse' do
          shift_name = @nurse.shift
          unit_name = Unit.find_by_id(@nurse.unit_id).name
          post :destroy, :id => @nurse.id
          response.should redirect_to nurse_manager_index_path(:admin=>{:shift => shift_name, :unit => unit_name})
        end
        it 'should flash a message if successfully updated' do
          nurse_name = @nurse.name
          post :destroy, :id => @nurse.id
          flash[:notice].should == "#{nurse_name} was removed from the system."
        end
      end
    end
  end

  describe 'FINALIZE' do
    before :each do
      @unit = FactoryGirl.create(:unit)
      @bad_unit = FactoryGirl.create(:unit)
      @shift = 'Days'
      @bad_shift = 'PMs'
      @nurse = FactoryGirl.create(:nurse, :unit_id => @unit.id, :shift => @shift)
      @bad_nurse = FactoryGirl.create(:nurse, :unit_id => @bad_unit, :shift => @bad_shift)
      @email = "blahblahblah"
    end
    it 'should flash a message indicating success' do
      post :finalize, :admin=>{:unit => @unit.name, :shift => @shift}
      flash[:notice].should == "This nurse list has been finalized and account creation emails have been sent for nurses in Unit #{@unit.name}, Days."
    end
    it 'should redirect to nurse view unit & shift page upon success' do
      post :finalize, :admin=>{:unit => @unit.name, :shift => @shift}
      response.should redirect_to nurse_manager_index_path(:admin=> {:unit=>@unit.name, :shift=>@shift})
    end
    it 'should still allow other nurses to be edited after finalization' do
      post :finalize, :admin=>{:unit => @unit.name, :shift => @shift}
      Nurse.stub(:find_by_id).and_return(@bad_nurse)
      @bad_nurse.name = "New Name Editing"
      @bad_nurse.save.should_not be_nil
    end
  end

  describe 'Finalize Vacation Schedule' do
    before :each do
      @shift = 'Days'
      @unit = FactoryGirl.create(:unit)
      @nurse = FactoryGirl.create(:nurse, :position=>1,:shift=>@shift,:unit=>@unit)
      @nurse_next = FactoryGirl.create(:nurse,:position=>2,:shift=>@shift,:unit=>@unit)
      @nurse_other = FactoryGirl.create(:nurse,:position=>1,:shift=>"PMs",:unit=>@unit)
      post :finalize_schedule, :id=>@nurse.id
    end
    it 'should make the current nurse the next nurse' do
      nurse = NurseBaton.find_by_unit_and_shift(@unit,@shift)
      nurse.current_nurse.should == @nurse_next.id
    end
  end


  describe 'Seniority List' do
    before(:each) do
      @unit = FactoryGirl.create(:unit)
      @nurses = FactoryGirl.create_list(:nurse, 5, :unit_id => @unit.id) # FactoryGirl creates this list in seniority order
      @nurse = @nurses[0]
    end

    it 'should query the Nurse model for nurse' do
      Nurse.should_receive(:find).and_return(@nurse)
      get :seniority, :nurse_id => @nurse.id
    end
    it 'should assign a list with nurses in descending order by seniority' do
      get :seniority, :nurse_id => @nurse.id
      assigns(:nurses).should == @nurses
    end
    it 'should assign columns to only display a name' do
      get :seniority, :nurse_id => @nurse.id
      assigns(:columns).should == ['name']
    end
  end

end
