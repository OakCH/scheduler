require 'spec_helper'

describe Admin do
  before(:each) do
    @admin = FactoryGirl.create(:admin)
    @nurse = FactoryGirl.create(:nurse)
    @start_at = '03/03/2012'
    @end_at = '03/04/2012'
  end
  describe 'view events for one month' do
    before(:each) do
      unit3 = FactoryGirl.create(:unit, :id=>3)
      unit2 = FactoryGirl.create(:unit, :id=>2)
      nurses = [FactoryGirl.create(:nurse, :unit_id=>3, :shift=>'Days')]
      nurses << FactoryGirl.create(:nurse, :unit_id=>3, :shift=>'Days')
      nurses << FactoryGirl.create(:nurse, :unit_id=>3, :shift=>'PMs')
      nurses << FactoryGirl.create(:nurse, :unit_id=>2, :shift=>'Days')
      for nurse in nurses
        event = Event.create!(:name => nurse.name, :start_at => @start_at, :end_at => @end_at, :nurse_id => nurse.id)
      end
    end
    it 'should show events of nurses constrainted by shift and unit with 1+ nurses' do
      Admin.show_events_for_month({:unit_id=>3, :shift=>'Days'}).length.should == 2
    end
    it 'should show events of nurses constrained by shift and unit with 1 nurse' do
      Admin.show_events_for_month({:unit_id=>2, :shift=>'Days'}).length.should == 1
    end
    it 'should show events of nurses constrained by unit only' do
      Admin.show_events_for_month({:unit_id=>3}).length.should == 3
    end
  end
end
