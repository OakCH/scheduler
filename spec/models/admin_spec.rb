require 'spec_helper'

describe Admin do
  before(:each) do
    @admin = FactoryGirl.create(:admin)
    @nurse = FactoryGirl.create(:nurse)
    @start_at = '03/03/2012'
    @end_at = '03/04/2012'
  end
  describe 'Admin should be able to' do
    describe 'do CRUD on events: ' do
      it 'should create an event for a specific nurse' do
        pending
        start_at = '03/03/2012'
        end_at = '03/04/2012'
        Admin.add_event(@start_at, @end_at, @nurse.id)
        events = Event.find(:all, :conditions => {:nurse_id => @nurse.id})
        events.length.should==1
        new_event = events[0]
        new_event.start_at.should == @start_at
        new_event.end_at.should == @end_at
        new_event.nurse_id.should == @nurse.id
        #what's the point of having Event.name when we already have nurse_id
        new_event.name.should == @nurse.name
      end
      describe 'modify events:' do
        before(:each) do
          @new_event = Event.create!(:name => @nurse.name, :start_at => @start_at,
                                    :end_at => @end_at, :nurse_id => @nurse.id)
          @new_event.should_not == nil
          @events = Event.find(:all, :conditions => {:id => @new_event.id})
          @events.length.should==1
          @nurse.events.length.should==1
        end
        it 'should delete an event' do
          pending
          Admin.delete_event(@events[0])
          events = Event.find(:all, :conditions => {:id => @new_event.id})
          events.length.should==0
          nurse_ex = Nurse.find_by_id(@nurse.id)
          nurse_ex.events.length.should==0
        end
        it 'should update an event' do
          pending
        end
      end
    end
    describe 'view events for one month' do
      it 'should retrieve events for one month for one shift and one unit' do
        
      end
    end
  end

end
