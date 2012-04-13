require 'spec_helper'

describe 'Unit' do
  describe 'checking max per day calculations' do
    before(:each) do
      @unit = FactoryGirl.create(:unit)
      FactoryGirl.create_list(:nurse, 4, :unit => @unit)
    end
    it 'should return 1 year for 40 accrued weeks' do
      @unit.calculate_max_per_day("PMs")
      Unit.max_per[:year].should == 1
    end
    it 'should return 0 months for 40 accrued weeks' do
      @unit.calculate_max_per_day("PMs")
      Unit.max_per[:month].should == 0
    end
    
    context 'for 46 accrued weeks' do
      before(:each) do
        FactoryGirl.create(:nurse, :unit => @unit, :num_weeks_off => 6)
      end
      it 'should return 1 year for 46 accrued weeks' do
        @unit.calculate_max_per_day("PMs")
        Unit.max_per[:year].should == 1
      end
      it 'should return 0 months for 46 accrued weeks' do
        @unit.calculate_max_per_day("PMs")
        Unit.max_per[:month].should == 0
      end
    end

    context '120 accrued weeks' do
      before(:each) do
        FactoryGirl.create_list(:nurse, 8, :unit => @unit)
      end
      it 'should return 2 years' do
        @unit.calculate_max_per_day("PMs")
        Unit.max_per[:year].should == 2
      end
      it 'should return 3 months' do
        @unit.calculate_max_per_day("PMs")
        Unit.max_per[:month].should == 3
      end
    end
  end
end
