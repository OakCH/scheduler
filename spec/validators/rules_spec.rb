require 'spec_helper'
require 'date'
require 'active_model'
require File.expand_path('app/validators/rules')
require 'rspec/rails/extensions'

class Validatable
  include ActiveModel::Validations
  validates_with Rules
end

describe Rules do
  describe 'check num_nurses_on_day' do
    before(:each) do
      @unit = FactoryGirl.create(:unit, :name => 'surgery')
      @nurse = FactoryGirl.create(:nurse, :name => 'e1', :shift => "PMs", :unit_id => @unit.id)
      FactoryGirl.create(:event, :name => 'e1', :start_at => DateTime.new(2012,4,4,0,0,0), :end_at => DateTime.new(2012,4,24,0,0,0), :nurse_id => @nurse.id)
    end

    it 'should return 1' do
      rules = Rules.new(nil)
      test_date = '10/04/2012'.to_date
      rules.num_nurses_on_day(test_date, @nurse.shift, @nurse.unit_id).should == 1
    end
  end

#  subject {Validatable.new}
#  before(:each) do
#    @nurse = FactoryGirl.create(:nurse, :num_weeks_off => 3)
#    @nurse_id = @nurse.id
#    subject.stub(:nurse_id).and_return(@nurse_id)
#    subject.stub(:nurse).and_return(@nurse)
#    Event.stub(:num_nurses_on_day).and_return(0)
#  end
#
#  describe 'checking is_week?' do
#    before(:each) do
#      subject.stub(:start_at).and_return(DateTime.new(2012,3,4,0,0,0))
#    end
#
#    it 'should return true given event of one week' do
#      subject.stub(:end_at).and_return(DateTime.new(2012,3,10,0,0,0))
#      subject.should be_valid
#    end
#
#    it 'should return true given event of 8 days' do
#      subject.stub(:end_at).and_return(DateTime.new(2012,3,11,0,0,0))
#      subject.should be_valid
#    end
#
#    it 'should return false given event of 6 days' do
#      subject.stub(:end_at).and_return(DateTime.new(2012,3,9,0,0,0))
#      subject.should have(1).error_on(:end_at)
#    end
#  end
#
#  describe 'checking less_than_allowed?' do
#    before(:each) do
#      # add 2 weeks of scheduled vacation into nurse
#      @event1 = FactoryGirl.create(:event, :start_at => DateTime.new(2012,3,4,0,0,0), :end_at => DateTime.new(2012,3,10,0,0,0))
#      @event2 = FactoryGirl.create(:event, :start_at => DateTime.new(2012,4,4,0,0,0), :end_at => DateTime.new(2012,4,10,0,0,0))
#      @nurse.events << @event1
#      @nurse.events << @event2
#      # this is the third week currently being validated
#      subject.stub(:start_at).and_return(DateTime.new(2012,5,4,0,0,0))
#      subject.stub(:end_at).and_return(DateTime.new(2012,5,10,0,0,0))
#    end
#    it 'should return true if taken 21 vacation days and have 28' do
#      @nurse.num_weeks_off = 4
#      subject.should be_valid
#    end
#    it 'should return true if taken 21 vacation days and have 21' do
#      subject.should be_valid
#    end
#    
#    it 'should return false if taken 28 vacation days and have 21' do
#      @event3 = FactoryGirl.create(:event, :start_at => DateTime.new(2012,6,4,0,0,0), :end_at => DateTime.new(2012,6,10,0,0,0))
#      @nurse.events << @event3
#      subject.should have(1).error_on(:allowed)
#    end
#  end
#
#  describe 'checking up_to_max_segs?' do
#    before(:each) do
#      #make sure @@max_segs = 4
#      # add 3 segs in
#      @nurse.num_weeks_off = 5
#      @event1 = FactoryGirl.create(:event, :start_at => DateTime.new(2012,3,4,0,0,0), :end_at => DateTime.new(2012,3,10,0,0,0), :nurse=>@nurse)
#      @event2 = FactoryGirl.create(:event, :start_at => DateTime.new(2012,4,4,0,0,0), :end_at => DateTime.new(2012,4,10,0,0,0), :nurse=>@nurse)
#      @nurse.events << @event1
#      @nurse.events << @event2
#      subject.stub(:start_at).and_return(DateTime.new(2012,5,4,0,0,0))
#      subject.stub(:end_at).and_return(DateTime.new(2012,5,10,0,0,0))
#    end
#    it 'should return true if 3 segs out of 4' do
#      subject.should be_valid
#    end
#    it 'should return true if 4 segs out of 4' do
#      @event3 = FactoryGirl.create(:event, :start_at => DateTime.new(2012,6,4,0,0,0), :end_at => DateTime.new(2012,6,10,0,0,0), :nurse=>@nurse)
#      @nurse.events << @event3
#      subject.should be_valid
#    end
#    it 'should return false if 5 segs out of 4' do
#      @event3 = FactoryGirl.create(:event, :start_at => DateTime.new(2012,6,4,0,0,0), :end_at => DateTime.new(2012,6,10,0,0,0), :nurse=>@nurse)
#      @nurse.events << @event3
#      @event4 = FactoryGirl.create(:event, :start_at => DateTime.new(2012,7,4,0,0,0), :end_at => DateTime.new(2012,7,10,0,0,0), :nurse=>@nurse)
#      @nurse.events << @event4
#      subject.should have(1).error_on(:segs)
#    end
#  end
#  
#  describe 'checking less_than_max_per_day?' do
#    context 'with 40 accrued weeks' do
#      before(:each) do
#        @unit = FactoryGirl.create(:unit, :name => 'Surgery')
#        @nurse1 = FactoryGirl.create(:nurse, :unit => @unit)
#        @nurse2 = FactoryGirl.create(:nurse, :unit => @unit)
#        FactoryGirl.create_list(:nurse, 2, :unit => @unit)
#      end
#      
#      it 'should should allow first person to schedule vacation' do
#        subject.stub(:start_at).and_return(DateTime.new(2012,4,12,0,0,0))
#        subject.stub(:end_at).and_return(DateTime.new(2012,4,18,0,0,0))
#        subject.stub(:nurse).and_return(@nurse1)
#        subject.stub(:nurse_id).and_return(@nurse1.id)
#        subject.should be_valid
#      end
#      it 'should not allow second person to schedule vacation on same day as first' do
#        Event.stub(:num_nurses_on_day).and_return(1)
#        subject.stub(:start_at).and_return(DateTime.new(2012,4,12,0,0,0))
#        subject.stub(:end_at).and_return(DateTime.new(2012,4,18,0,0,0))
#        subject.stub(:nurse).and_return(@nurse2)
#        subject.stub(:nurse_id).and_return(@nurse2.id)
#        subject.should have(1).error_on(:max_day)
#      end
#    end
#    
#    context 'with 50 accrued weeks, extra 3 months Apr-June' do
#      before(:each) do
#        @unit = FactoryGirl.create(:unit, :name => 'Surgery')
#        @nurse1 = FactoryGirl.create(:nurse, :unit => @unit)
#        @nurse2 = FactoryGirl.create(:nurse, :unit => @unit)
#        @nurse3 = FactoryGirl.create(:nurse, :unit => @unit)
#        FactoryGirl.create_list(:nurse, 2, :unit => @unit)
#        Event.stub(:additional_months).and_return([4, 5, 6])
#      end
#      
#      it 'should allow first person to schedule vacation' do
#        subject.stub(:start_at).and_return(DateTime.new(2012,4,12,0,0,0))
#        subject.stub(:end_at).and_return(DateTime.new(2012,4,18,0,0,0))
#        subject.stub(:nurse).and_return(@nurse1)
#        subject.stub(:nurse_id).and_return(@nurse1.id)
#        subject.should be_valid
#      end
#      it 'should allow second person to schedule vacation on overlapping days as first' do
#        Event.stub(:num_nurses_on_day).and_return(1)
#        subject.stub(:start_at).and_return(DateTime.new(2012,4,15,0,0,0))
#        subject.stub(:end_at).and_return(DateTime.new(2012,4,21,0,0,0))
#        subject.stub(:nurse).and_return(@nurse2)
#        subject.stub(:nurse_id).and_return(@nurse2.id)
#        subject.should be_valid
#      end
#      it 'should not allow third person to schedule vacation on overlapping days as first' do
#        Event.stub(:num_nurses_on_day).and_return(2)
#        subject.stub(:start_at).and_return(DateTime.new(2012,4,7,0,0,0))
#        subject.stub(:end_at).and_return(DateTime.new(2012,4,13,0,0,0))
#        subject.stub(:nurse).and_return(@nurse3)
#        subject.stub(:nurse_id).and_return(@nurse3.id)
#        subject.should have(1).error_on(:max_day)
#      end
#    end
#  end
  
end
