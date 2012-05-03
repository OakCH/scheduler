require 'spec_helper'

describe 'Class methods' do
  before(:each) do
    @shift = 'Days'
    @unit = FactoryGirl.create(:unit)
    @month_obj = UnitAndShift.create(:unit => @unit, :shift => @shift, :additional_month => 1)
    @holiday_obj = UnitAndShift.create(:unit => @unit, :shift => @shift, :holiday => 1)
  end
  
  it 'should return [1] when queried for additional months' do
    UnitAndShift.get_additional_months(@unit.id, @shift).should == [1]
  end
  
  it 'should return one record when queried for add_month_objs' do
    UnitAndShift.get_add_month_objs(@unit.id, @shift).should == [@month_obj]
  end
  
  it 'should return one record when queried for holiday_objs' do
    UnitAndShift.get_holiday_obj(@unit.id, @shift).should == @holiday_obj
  end
  
  describe 'destroy unit dependencies' do
    it 'should remove unit_and_shift when unit destroyed' do
      unit_id = @unit.id
      @unit.destroy
      UnitAndShift.find_all_by_unit_id(unit_id).should be_empty
    end
  end
end
