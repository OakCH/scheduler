require 'spec_helper'

describe 'Unit' do
  describe 'checking max per day calculations' do
    before(:each) do
      @unit = FactoryGirl.create(:unit, :name => 'Surgery')
      FactoryGirl.create_list(:nurse, 4, :unit => @unit)
    end
    it 'should return 1 year for 40 accrued weeks' do
      max_per = @unit.calculate_max_per_day(@unit.id, "PMs")
      max_per[:year].should == 1
    end
    it 'should return 0 months for 40 accrued weeks' do
      max_per = @unit.calculate_max_per_day(@unit.id, "PMs")
      max_per[:month].should == 0
    end
    
    context 'for 46 accrued weeks' do
      before(:each) do
        FactoryGirl.create(:nurse, :unit => @unit, :num_weeks_off => 6)
      end
      it 'should return 1 year' do
        max_per = @unit.calculate_max_per_day(@unit.id, "PMs")
        max_per[:year].should == 1
      end
      it 'should return 0 months' do
        max_per = @unit.calculate_max_per_day(@unit.id, "PMs")
        max_per[:month].should == 0
      end
    end
    
    context 'for 60 accrued weeks' do
      before(:each) do
        FactoryGirl.create_list(:nurse, 2, :unit => @unit)
      end
      it 'should return 1 year' do
        max_per = @unit.calculate_max_per_day(@unit.id, "PMs")
        max_per[:year].should == 1
      end
      it 'should return 2 months' do
        max_per = @unit.calculate_max_per_day(@unit.id, "PMs")
        max_per[:month].should == 2
      end
    end

    context '120 accrued weeks' do
      before(:each) do
        FactoryGirl.create_list(:nurse, 8, :unit => @unit)
      end
      it 'should return 2 years' do
        max_per = @unit.calculate_max_per_day(@unit.id, "PMs")
        max_per[:year].should == 2
      end
      it 'should return 3 months' do
        max_per = @unit.calculate_max_per_day(@unit.id, "PMs")
        max_per[:month].should == 3
      end
    end
  end
end
