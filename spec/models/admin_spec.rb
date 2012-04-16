require 'spec_helper'
require 'date'

describe Admin do
  before(:each) do
    #@admin = FactoryGirl.create(:admin)
    #@nurse = FactoryGirl.create(:nurse)
  end
  describe 'view events for one month' do
    before(:each) do
      @unit3 = FactoryGirl.create(:unit)
      @unit2 = FactoryGirl.create(:unit)
      nurses = []
      nurses << [FactoryGirl.create(:nurse, :num_weeks_off=>5, :unit=>@unit3, :shift=>'Days'),DateTime.new(2012,3,3,0,0,0),DateTime.new(2012,3,9,0,0,0)]
      nurses << [FactoryGirl.create(:nurse, :num_weeks_off=>5, :unit=>@unit3, :shift=>'Days'),DateTime.new(2012,3,10,0,0,0),DateTime.new(2012,3,16,0,0,0)]
      nurses << [FactoryGirl.create(:nurse, :num_weeks_off=>5, :unit=>@unit3, :shift=>'PMs'),DateTime.new(2012,3,5,0,0,0),DateTime.new(2012,3,11,0,0,0)]
      nurses << [FactoryGirl.create(:nurse, :num_weeks_off=>5, :unit=>@unit2, :shift=>'Days'),DateTime.new(2012,3,5,0,0,0),DateTime.new(2012,3,11,0,0,0)]
      nurses << [FactoryGirl.create(:nurse, :num_weeks_off=>5, :unit=>@unit3, :shift=>'Days'),DateTime.new(2012,5,5,0,0,0),DateTime.new(2012,5,11,0,0,0)]
      nurses << [FactoryGirl.create(:nurse, :num_weeks_off=>5, :unit=>@unit3, :shift=>'Days'),DateTime.new(2012,5,5,0,0,0),DateTime.new(2012,5,11,0,0,0)]
      for nurse,start_date,end_date in nurses
        nurse.events << FactoryGirl.create(:event, :start_at => start_date, :end_at => end_date)
        nurse.save
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
      Admin.show_events_for_month(5,2012,{:unit_id=>@unit3.id}).length.should == 1
    end
  end
end
