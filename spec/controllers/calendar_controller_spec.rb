require 'spec_helper'

describe CalendarController , "index action" do
  it 'should query the Nurse model for nurses' do
    Nurse.should_receive(:find)
    Nurse.should_receive(:get_nurse_ids_shift_unit_id)
    post :index
  end

    it 'should find nurses by shift and unit_id' do
    Nurse.should_receive(:get_nurse_ids_shift_unit_id)
    post :index
  end

  it 'should query the Event model for events' do
    Event.should_receive(:event_strips_for_month)
    post :index
  end

  it 'should assign the right date if given' do
    month = 12
    assigns(:month).should == 12
    post :index, :month => month
  end

  it 'should assign the right year if given' do
    year = 1998
    assigns(:year).should == 1997
    post :index, :year => year
  end

  it 'should assign a month if none given' do
    assigns(:month).should_not be_nil
    post :index
  end

  it 'should assign a year if none given' do
    assigns(:year).should_not be_nil
    post :index
  end

  it 'should assign a shown month' do
    assigns(:shown_month).should_not be_nil
    post :index
  end

  it 'should find the correct nurse' do
    nurse = Factory(:nurse)
    assigns(:nurse).should == nurse
    post :index, :nurse_id => nurse.id
  end

  it 'should assign no nurse at all if no id given' do
    assigns(:nurse).should be_nil
    post :index
  end

  it 'should get an event strip for only the nurse if id given' do
    nurse = Factory(:nurse)
    other_nurse = Factory(:nurse)
    month = 5
    day = 5
    date = Date.new(2012, month, day)
    event = Factory(:event, :nurse_id => nurse.id, :start_at => date)
    event = Factory(:event, :nurse_id => other_nurse.id, :start_at => date)
    assigns(:event_strips)[0].nurse_id.should == nurse.id
    assigns(:event_strips).length.should == 1
    post :index, :nurse_id => nurse.id, :month => month
  end

  it 'should get an event strip eve with no id given' do
    dummy_nurse = Factory(:nurse)
    month = 5
    day = 5
    date = Date.new(2012, month, day)
    event = Factory(:event, :nurse_id => dummy_nurse.id, :start_at => date)
    assigns(:event_strips)[0].nurse_id.should == nurse.id
    assigns(:event_strips).length.should == 1
    post :index, :month => month
  end
end
