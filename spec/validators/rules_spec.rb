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
  subject {Validatable.new}
  before(:each) do
    @nurse = FactoryGirl.create(:nurse)
    @nurse_id = @nurse.id
    subject.stub(:nurse_id).and_return(@nurse_id)
    subject.stub(:nurse).and_return(@nurse)
  end

  describe 'checking is_week?' do

    it 'should return true given event of one week' do
      subject.stub(:start_at).and_return(DateTime.new(2012,3,4,0,0,0))
      subject.stub(:end_at).and_return(DateTime.new(2012,3,10,0,0,0))
      subject.should be_valid
    end

    it 'should return true given event of 8 days' do
      subject.stub(:start_at).and_return(DateTime.new(2012,3,4,0,0,0))
      subject.stub(:end_at).and_return(DateTime.new(2012,3,11,0,0,0))
      subject.should be_valid
    end

    it 'should return false given event of 6 days' do
      subject.stub(:start_at).and_return(DateTime.new(2012,3,4,0,0,0))
      subject.stub(:end_at).and_return(DateTime.new(2012,3,9,0,0,0))
      subject.should have(1).error_on(:end_at)
    end
  end

  describe 'checking less_than_allowed?' do
    before (:each) do
      @nurse = FactoryGirl.create(:nurse)
      @event = FactoryGirl.create(:event, :nurse_id => @nurse.id)
    end
    it 'should return true if taken 23 vacation days and have 25'
    it 'should return true if taken 23 vacation days and have 23'
    it 'should return false if taken 25 vacation days and have 23'
  end

  describe 'checking up_to_4_segs?'
  
  describe 'calculating the length of an event' do
    it 'should return true for an event from 4/11/12 to 4/17/12'
    it 'should return false for an event from 4/11/12 to 4/18/12'
    it 'should return false for an event from 4/11/12 to 4/16/12'
  end
end