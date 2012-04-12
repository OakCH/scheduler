require 'spec_helper'
require 'date'

describe Rules do
    describe 'checking is_week?' do        
        it 'should return true given event of one week' do
            record = FactoryGirl.create(:event, :start_at => DateTime.new(2012,3,4,0,0,0), :end_at => DateTime.new(2012,3,10,0,0,0)) 
            Rules.is_week?(record).should == true
        end
        
        it 'should return true given event of 8 days' do
            record = FactoryGirl.create(:event, :start_at => DateTime.new(2012,3,4,0,0,0), :end_at => DateTime.new(2012,3,11,0,0,0)) 
            Rules.is_week?(record).should == true
        end
        
        it 'should return false given event of 4 days' do
            record = FactoryGirl.create(:event, :start_at => DateTime.new(2012,3,4,0,0,0), :end_at => DateTime.new(2012,3,7,0,0,0)) 
            Rules.is_week?(record).should == false
        end
   end
   
   describe 'checking less_than_allowed?' do
       it 'should return true if taken 23 vacation days and have 25'
       it 'should return true if taken 23 vacation days and have 23'
       it 'should return false if taken 25 vacation days and have 23'
   end
   
   describe 'calculating the length of an event' do
       it 'should return true for an event from 4/11/12 to 4/17/12'
       it 'should return false for an event from 4/11/12 to 4/18/12'
       it 'should return false for an event from 4/11/12 to 4/16/12'
   end
end