require 'spec_helper'
require 'date'

describe CalendarController do

  before(:each){ @nurse = FactoryGirl.create(:nurse) }

  describe "nurse index action" do

    it 'should query the Nurse model for nurses' do
      Nurse.should_receive(:find_by_id)
      get :index, :nurse_id => @nurse.id
    end

    it 'should query the Event model for events' do
      Event.should_receive(:event_strips_for_month)
      get :index, :nurse_id => @nurse.id
    end

    it 'should assign the right month if given' do
      month = 12
      get :index, :nurse_id => @nurse.id, :month => month
      assigns(:month).should == 12
    end

    it 'should assign the right year if given' do
      year = 1998
      get :index, :nurse_id => @nurse.id, :year => year
      assigns(:year).should == 1998
    end

    it 'should assign a month if none given' do
      get :index, :nurse_id => @nurse.id
      assigns(:month).should_not be_nil
    end

    it 'should assign a year if none given' do
      get :index, :nurse_id => @nurse.id
      assigns(:year).should_not be_nil
    end

    it 'should assign a shown month' do
      get :index, :nurse_id => @nurse.id
      assigns(:shown_month).should_not be_nil
    end

    it 'should find the correct nurse' do
      get :index, :nurse_id => @nurse.id
      assigns(:nurse).should == @nurse
    end

    it 'should assign no nurse at all if the id does not belong to a nurse' do
      other_nurse = Nurse.find_by_id(@nurse.id + 1)
      other_nurse.destroy if other_nurse
      get :index, :nurse_id => @nurse.id + 1
      assigns(:nurse).should be_nil
    end

    it 'should get an event strip for only the current nurse, if id given' do
      other_nurse = FactoryGirl.create(:nurse)
      month = 5
      day = 5
      date = Date.new(2012, month, day)
      event = FactoryGirl.create(:event, :nurse_id => @nurse.id, :start_at => date)
      event2 = FactoryGirl.create(:event, :nurse_id => other_nurse.id, :start_at => date)
      get :index, :nurse_id => @nurse.id, :month => month
      nurse_assigned = false
      assigns(:event_strips).each do |d|
        d.each do |e|
          if e and e.nurse_id ==  @nurse.id then
            nurse_assigned = true
          end
        end
      end
      nurse_assigned.should be_true
    end

    it 'should get an event strip that is all nil with no id given' do
      dummy_nurse = FactoryGirl.create(:nurse)
      month = 5
      day = 5
      date = Date.new(2012, month, day)
      event = FactoryGirl.create(:event, :nurse_id => dummy_nurse.id, :start_at => date)
      get :index, :nurse_id => @nurse.id, :month => month
      assigns(:event_strips).each do |s|
        s.each do |e|
          e.should be_nil
        end
      end
    end
  end

  describe 'admin index action' do

    it 'should assign the right month if given' do
      month = 12
      get :admin_index, :month => month
      assigns(:month).should == 12
    end

    it 'should assign the right year if given' do
      year = 1998
      get :admin_index, :year => year
      assigns(:year).should == 1998
    end

    it 'should assign a month if none given' do
      get :admin_index
      assigns(:month).should_not be_nil
    end

    it 'should assign a year if none given' do
      get :admin_index
      assigns(:year).should_not be_nil
    end

    it 'should assign a shown month' do
      get :admin_index
      assigns(:shown_month).should_not be_nil
    end

    it 'should assign session shift and unit_id' do
      unit = FactoryGirl.create(:unit)
      get :admin_index, :shift => "PMs", :unit_id => unit.id
      session[:shift].should == "PMs"
      session[:unit_id].should == unit.id.to_s
      assigns(:shift).should == "PMs"
      assigns(:unit_id).should == unit.id.to_s
    end

    it 'should not assign session shift or unit_id if one is missing' do
      old_shift = session[:shift]
      old_unit_id = session[:unit_it]
      get :admin_index, :shift => "PMs"
      session[:shift].should == old_shift
      session[:unit_id].should == old_unit_id
      assigns(:shift).should == old_shift
      assigns(:unit_id).should == old_unit_id
    end

    it 'should call shift from Unit and find' do
      Unit.should_receive(:shifts)
      Unit.should_receive(:find)
      get :admin_index
    end

    it 'should call get_nurse_ids_shift_unit_id form Nurse' do
      Nurse.should_receive(:get_nurse_ids_shift_unit_id)
      unit = FactoryGirl.create(:unit)
      get :admin_index, :shift => "PMs", :unit_id => unit.id
    end

    it 'should assign event_strips' do
      unit = FactoryGirl.create(:unit)
      get :admin_index, :shift => "PMs", :unit_id => unit.id
      assigns(:event_strips).should_not be_nil
    end

    describe 'no units exist' do
      it 'should redirect to the login page' do
        get :admin_index, :unit_id => nil
        response.should redirect_to(login_path)
      end
      it 'should flash an error message after redirect' do
        get :admin_index, :unit_id => nil
        flash[:error].should_not be_empty
      end
    end

  end

  describe "Show" do

    it 'should find right event given id' do
      event = FactoryGirl.create(:event)
      get :show, :id => event.id, :nurse_id => @nurse.id
      assigns(:event).id.should == event.id
    end
  end

  describe "New" do
    it 'should assign right nurse id given id' do
      get :new, :nurse_id => @nurse.id
      assigns(:nurse_id).should == @nurse.id
    end
  end

  describe "Create" do

    before :each do
      @new_event = { :name => "My day off",
        :start_at => DateTime.now,
        :end_at => 2.days.from_now,
        :all_day => true }
    end

    it 'should increase the count of nurses' do
      nurse_count = Nurse.all.length
      post :create, :nurse_id => @nurse.id, :event => @new_event
      Nurse.all.length.should == nurse_count + 1
    end

    it 'should increase the count of events assoc with nurse' do
      event_count = @nurse.events.length
      post :create, :nurse_id => @nurse.id, :event => @new_event
      @nurse.events.length.should == event_count + 1
    end

    it 'should redirect' do
      post :create, :nurse_id => @nurse.id, :event => @new_event
      response.should redirect_to(nurse_calendar_index_path, :month => @new_event[start_at].month, :year => @new_event[start_at].year )
    end
  end

  describe "Edit" do



    it 'should assign the whatever is in params' do
      event = FactoryGirl.create(:event)
      get :edit, :id => event.id, :nurse_id => 2
      assigns(:id).should == event.id
      assigns(:nurse_id).should == 2
    end

  end

  describe "Update" do

    it 'should call find from Event' do
      event = FactoryGirl.create(:event)
      Event.should_receive(:find)
      get :update, :id => event.id, :nurse_id => @nurse.id,
      :event => { :name => "My day off" }
    end

    it 'should call update attributes! on the event' do
      event = FactoryGirl.create(:event)
      event.should_receive(:update_atrributes!)
      get :update, :id => event.id, :nurse_id => @nurse.id,
      :event => { :name => "My day off" }
    end

    it 'should update the event' do
      event = FactoryGirl.create(:event)
      get :update, :id => event.id, :nurse_id => @nurse.id,
      :event => { :name => "My day off" }
      assigns(:event).name.should == "My day off"
    end

    it 'should redirect' do
      event = FactoryGirl.create(:event)
      get :update, :id => event.id, :nurse_id => @nurse.id,
      :event => { :name => "My day off" }
      response.should redirect_to(nurse_calendar_index_path(:month => event.start_at.month, :year => event.start_at.year))
    end

  end

  describe "Destroy" do

    it 'should call find from Event' do
      nurse = FactoryGirl.create(:nurse)
      event = FactoryGirl.create(:event)
      Event.should_receive(:find)
      delete :destroy, :id => event.id, :nurse_id => nurse.id
    end

    it 'should call destroy on the event' do
      nurse = FactoryGirl.create(:nurse)
      event = FactoryGirl.create(:event)
      delete :destroy, :id => event.id, :nurse_id => nurse.id
    end


    it 'should redirect' do
      event = FactoryGirl.create(:event)
      nurse = FactoryGirl.create(:nurse)
      delete :destroy, :id => event.id, :nurse_id => nurse.id
      response.should redirect_to(nurse_calendar_index_path)
    end

  end

end


