require 'spec_helper'
require 'date'

describe Admin do
  before(:each) do
    @admin = FactoryGirl.create(:admin)
    @nurse = FactoryGirl.create(:nurse)
    @start_at = '03/03/2012'
    @end_at = '11/11/2012'
  end
  describe 'view events for one month' do
    before(:each) do
      @unit3 = FactoryGirl.create(:unit)
      @unit2 = FactoryGirl.create(:unit)
      nurses = []
      nurses << [FactoryGirl.create(:nurse, :unit=>@unit3, :shift=>'Days'),DateTime.new(2012,3,3,0,0,0)]
      nurses << [FactoryGirl.create(:nurse, :unit=>@unit3, :shift=>'Days'),DateTime.new(2012,3,5,0,0,0)]
      nurses << [FactoryGirl.create(:nurse, :unit=>@unit3, :shift=>'PMs'),DateTime.new(2012,3,5,0,0,0)]
      nurses << [FactoryGirl.create(:nurse, :unit=>@unit2, :shift=>'Days'),DateTime.new(2012,3,5,0,0,0)]
      nurses << [FactoryGirl.create(:nurse, :unit=>@unit3, :shift=>'Days'),DateTime.new(2012,5,5,0,0,0)]
      nurses << [FactoryGirl.create(:nurse, :unit=>@unit3, :shift=>'Days'),DateTime.new(2011,5,5,0,0,0)]
      for nurse,start_date in nurses
        event = Event.create!(:name => nurse.name, :start_at => start_date, :end_at => @end_at, :nurse_id => nurse.id)
      end
    end
    it 'should show events of nurses constrainted by shift and unit with 1+ nurses' do
      Admin.show_events_for_month(3,2012,{:unit_id=>@unit3.id, :shift=>'Days'}).length.should == 2
    end
    it 'should show events of nurses constrained by shift and unit with 1 nurse' do
      Admin.show_events_for_month(3,2012,{:unit_id=>@unit2.id, :shift=>'Days'}).length.should == 1
    end
    it 'should show events of nurses constrained by unit only' do
      Admin.show_events_for_month(3,2012,{:unit_id=>@unit3.id}).length.should == 3
    end
    it 'should not show events in other months and years' do
      Admin.show_events_for_month(5,2011,{:unit_id=>@unit3.id}).length.should == 1
    end
  end
end
