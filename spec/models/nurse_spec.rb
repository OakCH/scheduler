require 'spec_helper'
require 'date'

describe Nurse do
  before(:each) do
    @nurse = Factory(:nurse)
  end
  describe 'Nurse owner should be able to' do
    describe 'do CRUD' do
      it 'should create an event' do
        start_at = '03/03/2012'
        end_at = '03/04/2012'
        @nurse.add_event(start_at, end_at)
        @nurse.events.length.should == 1
        event = @nurse.events[0].name
        event.name.should == @nurse.name
        event.start_at.should == start_at
        event.end_at.should == end_at
      end
      it 'should delete an event'
      it 'should update an event'
    end
    describe 'view all events she owns' do
      it 'should retrieve all events nurse owns'
    end
  end
end
