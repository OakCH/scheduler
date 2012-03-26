require 'spec_helper'
require 'date'

describe CalendarController do
  describe "index action" do

    it 'should query the Nurse model for nurses' do
      Nurse.should_receive(:find)
      Nurse.should_receive(:get_nurse_ids_shift_unit_id)
      post :index
    end

    it 'should find nurses by shift and unit_id' do
      Nurse.should_receive(:get_nurse_ids_shift_unit_id)
      post :index
    end

    it 'should query the Event model for events' do
      Event.should_receive(:event_strips_for_month)
      post :index
    end

    it 'should assign the right date if given' do
      month = 12
      post :index, :month => month
      assigns(:month).should == 12
    end

    it 'should assign the right year if given' do
      year = 1998
      post :index, :year => year
      assigns(:year).should == 1997
    end

    it 'should assign a month if none given' do
      post :index
      assigns(:month).should_not be_nil
    end

    it 'should assign a year if none given' do
      post :index
      assigns(:year).should_not be_nil
    end

    it 'should assign a shown month' do
      post :index
      assigns(:shown_month).should_not be_nil
    end

    it 'should find the correct nurse' do
      nurse = FactoryGirl.create(:nurse)
      post :index, :nurse_id => nurse.id
      assigns(:nurse).should == nurse
    end

    it 'should assign no nurse at all if no id given' do
      post :index
      assigns(:nurse).should be_nil
    end

    it 'should get an event strip for only the nurse if id given' do
      nurse = FactoryGirl.create(:nurse)
      other_nurse = FactoryGirl.create(:nurse)
      month = 5
      day = 5
      date = Date.new(2012, month, day)
      event = FactoryGirl.create(:event, :nurse_id => nurse.id, :start_at => date)
      event = FactoryGirl.create(:event, :nurse_id => other_nurse.id, :start_at => date)
      post :index, :nurse_id => nurse.id, :month => month
      assigns(:event_strips)[0].nurse_id.should == nurse.id
    end

    it 'should get an event strip eve with no id given' do
      dummy_nurse = FactoryGirl.create(:nurse)
      month = 5
      day = 5
      date = Date.new(2012, month, day)
      event = FactoryGirl.create(:event, :nurse_id => dummy_nurse.id, :start_at => date)
      post :index, :month => month
      assigns(:event_strips)[0].nurse_id.should == nurse.id
    end
  end

  describe 'admin_index' do

    it 'should assign the right date if given' do
      month = 12
      post :admin_index, :month => month
      assigns(:month).should == 12
    end

    it 'should assign the right year if given' do
      year = 1998
      post :admin_index, :year => year
      assigns(:year).should == 1998
    end

    it 'should assign a month if none given' do
      post :admin_index
      assigns(:month).should_not be_nil
    end

    it 'should assign a year if none given' do
      post :admin_index
      assigns(:year).should_not be_nil
    end

    it 'should assign a shown month' do
      post :admin_index
      assigns(:shown_month).should_not be_nil
    end

    it 'should assign session shift and unit_id' do
      unit = FactoryGirl.create(:unit)
      post :admin_index, :shift => "PMs", :unit_id => unit.id
      session[:shift].should == "PMs"
      session[:unit_id].should == "Surgery"
      assigns(:shift).should == "PMs"
      assigns(:unit_id).should == "Surgery"
    end

    it 'should not assign session shift or unit_id if one is missing' do
      old_shift = session[:shift]
      old_unit_id = session[:unit_it]
      post :admin_index, :shift => "PMs"
      session[:shift].should == old_shift
      session[:unit_id].should == old_unit_id
      assigns(:shift).should == old_shift
      assigns(:unit_id).should == old_unit_id
    end

    it 'should call shift from Unit and find' do
      Unit.should_receive(:shifts)
      Unit.should_receive(:find)
      post :admin_index
    end

    it 'should call get_nurse_ids_shift_unit_id form Nurse' do
      Nurse.should_receive(:get_nurse_ids_shift_unit_id)
      unit = FactoryGirl.create(:unit)
      post :admin_index, :shift => "PMs", :unit_id => unit.id
    end

    it 'should assign event_strips' do
      unit = FactoryGirl.create(:unit)
      post :admin_index, :shift => "PMs", :unit_id => unit.id
      assigns(:event_strips).should_not be_nil
    end

  end

  describe "Show" do
    it 'should assign nothing if there is no id' do
      post :show
      assigns(:event).should_be nil
    end

    it 'should find right event given id' do
      event = FactoryGirl.create(:event)
      post :show, :id => event.id
      assigns(:event).id.should == event.id
    end
  end

  describe "New" do
    it 'should assign nothing if there is no nurse id' do
      post :new
      assigns(:nurse_id).should_be nil
    end

    it 'should assign right nurse id given id' do
      nurse = FactoryGirl.create(:nurse)
      post :new, :id => nurse.id
      assigns(:nurse_id).should == nurse.id
    end
  end

  describe "Create" do
    it 'should increase the count of nurses' do
      nurse_count = Nurse.all.length
      nurse = FactoryGirl.create(:nurse)
      post :create, :nurse_id => nurse.id,
      :event => {:name => "My day off",
        :start_at => DateTime.now,
        :end_at => 2.days.from_now,
        :all_day => true
      }
      Nurse.all.length.should == nurse_count + 1
    end

    it 'should increase the count of events assoc with nurse' do
      nurse = FactoryGirl.create(:nurse)
      event_count = nurse.events.length
      post :create, :nurse_id => nurse.id,
      :event => {:name => "My day off",
        :start_at => DateTime.now,
        :end_at => 2.days.from_now,
        :all_day => true
      }
      nurse.events.length.should == event_count + 1
    end

    it 'should redirect' do
      nurse = FactoryGirl.create(:nurse)
      post :create, :nurse_id => nurse.id,
      :event => {:name => "My day off",
        :start_at => DateTime.now,
        :end_at => 2.days.from_now,
        :all_day => true
      }
      response.should redirect_to(nurse_calendar_index_path)
    end
  end

  describe "Edit" do

    it 'should assign nothing to anything if no params given' do
      post :edit
      assigns(:event).should_be nil
      assigns(:nurse_id).should_be nil
      assigns(:id).should_be nil
    end

    it 'should assign the whatever is in params' do
      event = FactoryGirl.create(:event)
      post :edit, :id => event.id, :nurse_id => 2
      assigns(:id).should == event.id
      assigns(:nurse_id).should == 2
    end

  end

  describe "Update" do

    it 'should do nothing if no id given' do
      post :update
      assigns(:event).should_be nil
    end

    it 'should call find from Event' do
      event = FactoryGirl.create(:event)
      Event.should_receive(:find)
      post :update, :id => event.id,
      :event => { :name => "My day off" }
    end

    it 'should call update attributes! on the event' do
      event = FactoryGirl.create(:event)
      event.should_receive(:update_atrributes!)
      post :update, :id => event.id,
      :event => { :name => "My day off" }
    end

    it 'should update the event' do
      event = FactoryGirl.create(:event)
      post :update, :id => event.id,
      :event => { :name => "My day off" }
      assigns(:event).name.should == "my day off"
    end

    it 'should redirect' do
      event = FactoryGirl.create(:event)
      post :update, :id => event.id,
      :event => { :name => "My day off" }
      response.should redirect_to(nurse_calendar_index_path)
    end

  end

  describe "Destroy" do
    it 'should do nothing if no id given' do
      post :destroy
      assigns(:event).should_be nil
    end

    it 'should call find from Event' do
      event = FactoryGirl.create(:event)
      Event.should_receive(:find)
      post :destroy, :id => event.id
    end

    it 'should call destroy on the event' do
      event = FactoryGirl.create(:event)
      event.should_receive(:destroy)
      post :destroy, :id => event.id
    end


    it 'should redirect' do
      nurse = FactoryGirl.create(:nurse)
      post :destroy, :id => nurse.id
      response.should redirect_to(nurse_calendar_index_path)
    end

  end

end


