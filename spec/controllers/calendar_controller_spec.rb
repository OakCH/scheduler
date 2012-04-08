require 'spec_helper'
require 'date'

describe CalendarController do
  
  before(:each) do
    @nurse = FactoryGirl.create(:nurse)
    @event = FactoryGirl.create(:event)
  end
  
  describe "nurse index action" do
    
    it 'should query the Nurse model for nurses' do
      Nurse.should_receive(:find_by_id).and_return(@nurse)
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
      date2 = Date.new(2012, month, day+6)
      event = FactoryGirl.create(:event, :nurse_id => @nurse.id, :start_at => date, :end_at => date2)
      event2 = FactoryGirl.create(:event, :nurse_id => other_nurse.id, :start_at => date, :end_at => date2)
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
      session[:shift] = "Days"
      session[:unit_id] = 3
      get :admin_index
      assigns(:shift).should == "Days"
      assigns(:unit_id).should == 3
    end
    
    it 'should assign event_strips' do
      unit = FactoryGirl.create(:unit)
      get :admin_index, :shift => "PMs", :unit_id => unit.id
      assigns(:event_strips).should_not be_nil
    end
    
  end
  
  describe "Show" do
    
    it 'should find right event given id' do
      get :show, :id => @event.id, :nurse_id => @nurse.id
      assigns(:event).should == @event
    end

  end
  
  describe "New" do
    it 'should assign right nurse id given id' do
      get :new, :nurse_id => @nurse.id
      assigns(:nurse_id).should == @nurse.id.to_s
    end
  end
  
  describe "Create" do
    
    before do
      @start = DateTime.parse("4-Apr-2012")
      @end = DateTime.parse("11-Apr-2012")
      @new_event = { :start_at => @start, :end_at => @end }
    end
    
    it 'should increase the count of events assoc with nurse' do
      event_count = @nurse.events.length
      post :create, :nurse_id => @nurse.id, :event => @new_event
      @nurse.reload
      @nurse.events.length.should == event_count + 1
    end
    
    it 'should redirect' do
      post :create, :nurse_id => @nurse.id, :event => @new_event
      response.should redirect_to(nurse_calendar_index_path(@nurse, :month => @new_event[:start_at].month, :year => @new_event[:start_at].year) )
    end
    
    it 'should assign the proper start at' do
      post :create, :nurse_id => @nurse.id, :event => @new_event
      event = Event.find_by_nurse_id_and_start_at(@nurse.id, @start.to_time)
      event.should_not be_nil
    end
    
    it 'should assign the proper end time' do
      post :create, :nurse_id => @nurse.id, :event => @new_event
      event = Event.find_all_by_nurse_id_and_end_at(@nurse.id, @end.to_time - 1)
      event.should_not be_nil
    end
    
    it 'should not allow an assignment of name' do
      @new_event[:name] = "New Name"
      post :create, :nurse_id => @nurse.id, :event => @new_event
      event = Event.find_by_nurse_id_and_start_at(@nurse.id, @start.to_time)
      event.name.should_not == "New Name"
    end
    
    it 'should not allow an assignment of nurse_id' do
      @new_event[:nurse_id] = (@nurse.id + 1).to_s
      post :create, :nurse_id => @nurse.id, :event => @new_event
      event = Event.find_by_nurse_id_and_start_at(@nurse.id, @start.to_time)
      event.nurse_id.should_not == @nurse.id + 1
    end
    
  end
  
  describe "Edit" do
    
    before { get :edit, :id => @event.id, :nurse_id => @nurse.id }
    
    it "should assign id to event.id" do
      assigns(:id).should == @event.id.to_s
    end
    
    it "should assign nurse_id to nurse.id" do
      assigns(:nurse_id).should == @event.id.to_s
    end
    
    it "should assign event to an instance of the event model" do
      assigns(:event).should == @event
    end
    
  end
  
  describe "Update" do
    
    it 'should call find from Event' do
      Event.should_receive(:find_by_id)
      put :update, :id => @event.id, :nurse_id => @nurse.id,
      :event => { :name => "My day off" }
    end
    
    it 'should call update attributes on the event' do
      Event.stub(:find_by_id).and_return(@event)
      @event.should_receive(:update_attributes)
      put :update, :id => @event.id, :nurse_id => @nurse.id,
      :event => { :name => "My day off" }
    end
    
    it 'should update the event' do
      put :update, :id => @event.id, :nurse_id => @nurse.id,
      :event => { :name => "My day off" }
      assigns(:event).name.should == "My day off"
    end
    
    it 'should redirect' do
      put :update, :id => @event.id, :nurse_id => @nurse.id,
      :event => { :name => "My day off" }
      response.should redirect_to(nurse_calendar_index_path(@nurse, :month => @event.start_at.month, :year => @event.start_at.year))
    end
    
  end
  
  describe "Destroy" do
    
    it 'should call find from Event' do
      Event.should_receive(:find_by_id)
      delete :destroy, :id => @event.id, :nurse_id => @nurse.id
    end
    
    it 'should call destroy on the event' do
      Event.stub(:find_by_id).and_return(@event)
      @event.should_receive(:destroy)
      delete :destroy, :id => @event.id, :nurse_id => @nurse.id
    end

    it 'should redirect' do
      delete :destroy, :id => @event.id, :nurse_id => @nurse.id
      response.should redirect_to(nurse_calendar_index_path(@nurse))
    end

  end

end


