require 'spec_helper'
require 'date'

describe CalendarController do
  
  context 'With authentication' do
    describe 'as an admin' do
      before(:each) do
        @admin = FactoryGirl.create(:admin)
        @nurse = FactoryGirl.create(:nurse)
        @event = FactoryGirl.create(:event, :nurse_id => @nurse.id)

        ApplicationController.stub('authenticate_any').and_return(1)
        ApplicationController.stub('authenticate_admin').and_return(1)
        ApplicationController.stub('admin_signed_in').and_return(1)

      end

      describe 'should save a range that is less than one week' do
        it 'should increase the count of events assoc with nurse' do
          event_count = @nurse.events.length
          @event.start_at = '12/4/2012'.to_date
          @event.end_at = '13/4/2012'.to_date
          post :create, :nurse_id => @nurse.id, :event => @event
          @nurse.reload
          @nurse.events.length.should == event_count + 1
        end
      end
    end
  end

#  context 'Without authentication' do
#    before(:all) do
#      CalendarController.skip_before_filter :authenticate_any!,
#      :authenticate_admin!, :check_nurse_id, :check_event_id
#    end
#
#    before(:each) do
#      @nurse = FactoryGirl.create(:nurse)
#      @event = FactoryGirl.create(:event, :nurse_id => @nurse.id)
#    end
#
#    describe "nurse index action" do
#
#      it 'should query the Nurse model for nurses' do
#        Nurse.should_receive(:find_by_id).and_return(@nurse)
#        get :index, :nurse_id => @nurse.id
#      end
#
#      it 'should query the Event model for events' do
#        Event.should_receive(:event_strips_for_month)
#        get :index, :nurse_id => @nurse.id
#      end
#
#      it 'should assign the right month if given' do
#        month = 12
#        get :index, :nurse_id => @nurse.id, :month => month
#        assigns(:month).should == 12
#      end
#
#      it 'should assign the right year if given' do
#        year = 1998
#        get :index, :nurse_id => @nurse.id, :year => year
#        assigns(:year).should == 1998
#      end
#
#      it 'should assign a month if none given' do
#        get :index, :nurse_id => @nurse.id
#        assigns(:month).should_not be_nil
#      end
#
#      it 'should assign a year if none given' do
#        get :index, :nurse_id => @nurse.id
#        assigns(:year).should_not be_nil
#      end
#
#      it 'should assign a shown month' do
#        get :index, :nurse_id => @nurse.id
#        assigns(:shown_month).should_not be_nil
#      end
#
#      it 'should find the correct nurse' do
#        get :index, :nurse_id => @nurse.id
#        assigns(:nurse).should == @nurse
#      end
#
#      it 'should assign no nurse at all if the id does not belong to a nurse' do
#        other_nurse = Nurse.find_by_id(@nurse.id + 1)
#        other_nurse.destroy if other_nurse
#        get :index, :nurse_id => @nurse.id + 1
#        assigns(:nurse).should be_nil
#      end
#
#      it 'should get an event strip for only the current nurse, if id given' do
#        other_nurse = FactoryGirl.create(:nurse)
#        month = 5
#        day = 5
#        date = Date.new(2012, month, day)
#        date2 = Date.new(2012, month, day+6)
#        event = FactoryGirl.create(:event, :nurse_id => @nurse.id, :start_at => date, :end_at => date2)
#        event2 = FactoryGirl.create(:event, :nurse_id => other_nurse.id, :start_at => date, :end_at => date2)
#        get :index, :nurse_id => @nurse.id, :month => month
#        nurse_assigned = false
#        assigns(:event_strips).each do |d|
#          d.each do |e|
#            if e and e.nurse_id ==  @nurse.id then
#              nurse_assigned = true
#            end
#          end
#        end
#        nurse_assigned.should be_true
#      end
#
#      it 'should get an event strip that is all nil with no id given' do
#        dummy_nurse = FactoryGirl.create(:nurse)
#        month = 5
#        day = 5
#        date = Date.new(2012, month, day)
#        event = FactoryGirl.create(:event, :nurse_id => dummy_nurse.id, :start_at => date)
#        get :index, :nurse_id => @nurse.id, :month => month
#        assigns(:event_strips).each do |s|
#          s.each do |e|
#            e.should be_nil
#          end
#        end
#      end
#    end
#    describe 'invalid nurse' do
#      invalid_inputs = ['53a',2343,'apple']
#      invalid_inputs.each do |input|
#        before :each do
#          get :index, :nurse_id => input 
#        end
#        it 'should redirect to the login calendar page' do
#          response.should redirect_to login_path
#        end
#        it 'should flash an error message after redirect' do
#          flash[:error].should_not be_empty
#        end
#      end
#    end
#
#    describe 'admin index action' do
#
#      it 'should assign the right month if given' do
#        month = 12
#        get :admin_index, :month => month
#        assigns(:month).should == 12
#      end
#
#      it 'should assign the right year if given' do
#        year = 1998
#        get :admin_index, :year => year
#        assigns(:year).should == 1998
#      end
#
#      it 'should assign a month if none given' do
#        get :admin_index
#        assigns(:month).should_not be_nil
#      end
#
#      it 'should assign a year if none given' do
#        get :admin_index
#        assigns(:year).should_not be_nil
#      end
#
#      it 'should assign a shown month' do
#        get :admin_index
#        assigns(:shown_month).should_not be_nil
#      end
#
#      it 'should assign session shift and unit_id' do
#        unit = FactoryGirl.create(:unit)
#        get :admin_index, :shift => "PMs", :unit_id => unit.id
#        session[:shift].should == "PMs"
#        session[:unit_id].should == unit.id.to_s
#        assigns(:shift).should == "PMs"
#        assigns(:unit_id).should == unit.id.to_s
#      end
#
#      it 'should not assign session shift or unit_id if one is missing' do
#        session[:shift] = "Days"
#        session[:unit_id] = 3
#        get :admin_index
#        assigns(:shift).should == "Days"
#        assigns(:unit_id).should == 3
#      end
#
#      it 'should assign event_strips' do
#        unit = FactoryGirl.create(:unit)
#        get :admin_index, :shift => "PMs", :unit_id => unit.id
#        assigns(:event_strips).should_not be_nil
#      end
#
#      describe 'invalid unit with valid shift' do
#        invalid_inputs = [nil,'53a',2343]
#        invalid_inputs.each do |input|
#          before :each do
#            FactoryGirl.create(:unit)
#            FactoryGirl.create(:unit)
#            unit = Unit.find_by_id(input)
#            if unit
#              unit.destroy
#            end
#            get :admin_index, {:unit_id => input,:shift=>'Days'}
#          end
#          it 'should redirect to the admin calendar page' do
#            response.should redirect_to admin_calendar_path
#          end
#          it 'should flash an error message after redirect' do
#            flash[:error].should_not be_empty
#          end
#        end
#      end
#
#      describe 'invalid unit without valid shift' do
#        invalid_inputs = [nil,'53a',2343]
#        invalid_inputs.each do |input|
#          before :each do
#            FactoryGirl.create(:unit)
#            FactoryGirl.create(:unit)
#            unit = Unit.find_by_id(input)
#            if unit
#              unit.destroy
#            end
#            get :admin_index, {:unit_id => input}
#          end
#          it 'should redirect to the admin calendar page' do
#            response.should redirect_to admin_calendar_path
#          end
#          it 'should flash an error message after redirect' do
#            flash[:error].should_not be_empty
#          end
#        end
#      end
#
#      describe 'no units exist' do
#        render_views
#        before :each do
#          units = Unit.find(:all)
#          units.each do |unit|
#            unit.destroy
#          end
#          get :admin_index
#        end
#        it 'should display a message indicating there are no units' do
#          response.body.should have_content('There are no units')
#        end
#        it 'should not show any events' do
#          assigns(:event_strips).flatten.compact.should be_empty
#        end
#        it 'should render the admin calendar template' do
#          response.should render_template('admin_index')
#        end
#      end
#
#      describe 'invalid shift with valid unit' do
#        invalid_inputs = [nil,'53a',2343,'apple']
#        invalid_inputs.each do |input|
#          before :each do
#            unit = FactoryGirl.create(:unit)
#            get :admin_index, {:shift => input, :unit => unit.id}
#          end
#          it 'should redirect to the admin calendar page' do
#            response.should redirect_to admin_calendar_path
#          end
#          it 'should flash an error message after redirect' do
#            flash[:error].should_not be_empty
#          end
#        end
#      end
#
#      describe 'invalid shift with no unit' do
#        invalid_inputs = [nil,'53a',2343,'apple']
#        invalid_inputs.each do |input|
#          before :each do
#            unit = FactoryGirl.create(:unit)
#            get :admin_index, {:shift => input}
#          end
#          it 'should redirect to the admin calendar page' do
#            response.should redirect_to admin_calendar_path
#          end
#          it 'should flash an error message after redirect' do
#            flash[:error].should_not be_empty
#          end
#        end
#      end
#
#      describe 'invalid shift with invalid unit' do
#        invalid_inputs = [nil,'53a',2343,'apple']
#        invalid_inputs.each do |input|
#          before :each do
#            unit = FactoryGirl.create(:unit)
#            get :admin_index, {:shift => input, :unit_id => input}
#          end
#          it 'should redirect to the admin calendar page' do
#            response.should redirect_to admin_calendar_path
#          end
#          it 'should flash an error message after redirect' do
#            flash[:error].should_not be_empty
#          end
#        end
#      end
#
#      describe 'month or day is zero' do
#        context 'month is zero' do
#          before :each do
#            get :admin_index, :month => 0
#          end
#          it 'should redirect to the login page' do
#            response.should redirect_to login_path
#          end
#          it 'should flash an error message after redirect' do
#            flash[:error].should_not be_empty
#          end
#        end
#        context 'year is zero' do
#          before :each do
#            get :admin_index, :year => 0
#          end
#          it 'should redirect to the login page' do
#            response.should redirect_to login_path
#          end
#          it 'should flash an error message after redirect' do
#            flash[:error].should_not be_empty
#          end
#        end
#      end
#    end
#    describe "Show" do
#      context 'valid event id' do
#        it 'should find right event given id' do
#          get :show, :id => @event.id, :nurse_id => @nurse.id
#          assigns(:event).should == @event
#        end
#      end
#      context 'invalid event id' do
#        invalid_ids = ['asdf','3afb',5234]
#        invalid_ids.each do |i|
#          before :each do
#            FactoryGirl.create(:event)
#            FactoryGirl.create(:event)
#            event = Event.find_by_id(i)
#            unless not event
#              event.destroy
#            end
#            get :show, :id => i, :nurse_id => @nurse.id
#          end
#          it 'should not find any events given id' do
#            assigns(:event).should be_nil
#          end
#          it 'should redirect to the login page' do
#            response.should redirect_to login_path 
#          end
#          it 'should flash an error message after redirect' do
#            flash[:error].should_not be_empty
#          end
#        end
#      end
#    end
#
#    describe "New" do
#      it 'should assign right nurse id given id' do
#        get :new, :nurse_id => @nurse.id
#        assigns(:nurse_id).should == @nurse.id.to_s
#      end
#    end
#
#    describe "Create" do
#      before do
#        @start = DateTime.parse("4-Apr-2012")
#        @end = DateTime.parse("11-Apr-2012")
#        @new_event = { :start_at => @start, :end_at => @end }
#      end
#
#      it 'should increase the count of events assoc with nurse' do
#        event_count = @nurse.events.length
#        post :create, :nurse_id => @nurse.id, :event => @new_event
#        @nurse.reload
#        @nurse.events.length.should == event_count + 1
#      end
#
#      it 'should redirect' do
#        post :create, :nurse_id => @nurse.id, :event => @new_event
#        response.should redirect_to(nurse_calendar_index_path(@nurse, :month => @new_event[:start_at].month, :year => @new_event[:start_at].year) )
#      end
#
#      it 'should assign the proper start at' do
#        post :create, :nurse_id => @nurse.id, :event => @new_event
#        event = Event.find_by_nurse_id_and_start_at(@nurse.id, @start.to_time)
#        event.should_not be_nil
#      end
#
#      it 'should assign the proper end time' do
#        post :create, :nurse_id => @nurse.id, :event => @new_event
#        event = Event.find_all_by_nurse_id_and_end_at(@nurse.id, @end.to_time - 1)
#        event.should_not be_nil
#      end
#
#      it 'should not allow an assignment of name' do
#        @new_event[:name] = "New Name"
#        post :create, :nurse_id => @nurse.id, :event => @new_event
#        event = Event.find_by_nurse_id_and_start_at(@nurse.id, @start.to_time)
#        event.name.should_not == "New Name"
#      end
#
#      it 'should not allow an assignment of nurse_id' do
#        @new_event[:nurse_id] = (@nurse.id + 1).to_s
#        post :create, :nurse_id => @nurse.id, :event => @new_event
#        event = Event.find_by_nurse_id_and_start_at(@nurse.id + 1, @start.to_time)
#        event.should be_nil
#      end
#
#      it 'should redirect to the nurse calendar index page if nurse.save fails' do
#        invalid_event = {:start_at=>'poppies', :end_at=>'4/5/2012'}
#        post :create, :nurse_id => @nurse.id, :event => invalid_event
#        response.should redirect_to nurse_calendar_index_path
#      end
#      it 'should flash an error message if nurse.save fails' do
#         invalid_event = {:start_at=>'poppies', :end_at=>'4/5/2012'}
#         post :create, :nurse_id => @nurse.id, :event => invalid_event
#         flash[:error].should_not be_empty
#      end
#    end
#
#    describe 'Create with invalid nurse id' do
#      before :each do
#        FactoryGirl.create(:nurse)
#        FactoryGirl.create(:nurse)
#        @new_event = FactoryGirl.create(:event)
#        @bad_id = '3abc'
#        nurse = Nurse.find_by_id(@bad_id)
#        unless not nurse
#          nurse.destroy
#        end
#        post :create, :nurse_id => @bad_id, :event => @new_event
#      end
#      it 'should not find a valid nurse' do
#        assigns(:nurse).should be_nil
#      end
#      it 'should redirect to the login page' do
#         response.should redirect_to login_path 
#      end
#      it 'should flash an error message after redirect' do
#         flash[:error].should_not be_empty
#      end
#    end
#
#    describe "Edit" do
#      before { get :edit, :id => @event.id, :nurse_id => @nurse.id }
#      it "should assign id to event.id" do
#        assigns(:id).should == @event.id.to_s
#      end
#
#      it "should assign nurse_id to nurse.id" do
#        assigns(:nurse_id).should == @event.id.to_s
#      end
#
#      it "should assign event to an instance of the event model" do
#        assigns(:event).should == @event
#      end
#
#    end
#
#    describe 'Edit with invalid event id' do
#      before :each do
#        FactoryGirl.create(:nurse)
#        @nurse = FactoryGirl.create(:event)
#        FactoryGirl.create(:event)
#        @bad_id = '3abc'
#        event = Event.find_by_id(@bad_id)
#        unless not event
#          event.destroy
#        end
#        post :edit, :id => @bad_id, :nurse_id => @nurse.id
#      end
#      it 'should not find a valid event' do
#        assigns(:event).should be_nil
#      end
#      it 'should redirect to the login page' do
#         response.should redirect_to login_path 
#      end
#      it 'should flash an error message after redirect' do
#         flash[:error].should_not be_empty
#      end
#    end
#
#    describe "Update" do
#
#      before do
#        @start = DateTime.parse("4-Apr-2012")
#        @end = DateTime.parse("11-Apr-2012")
#        @event_attr = { :start_at => @start, :end_at => @end }
#      end
#
#      it 'should call find from Event' do
#        Event.should_receive(:find_by_id)
#        put :update, :id => @event.id, :nurse_id => @nurse.id, :event => @event_attr
#      end
#
#      it 'should call update attributes on the event' do
#        Event.stub(:find_by_id).and_return(@event)
#        @event.should_receive(:update_attributes)
#        put :update, :id => @event.id, :nurse_id => @nurse.id, :event => @event_attr
#      end
#
#      it 'should update the start at' do
#        put :update, :id => @event.id, :nurse_id => @nurse.id, :event => @event_attr
#        assigns(:event).start_at.should == @start.to_time
#      end
#
#      it 'should update the end at' do
#        put :update, :id => @event.id, :nurse_id => @nurse.id, :event => @event_attr
#        assigns(:event).end_at.should == DateTime.parse("12-Apr-2012").to_time - 1
#      end
#
#      it 'should redirect' do
#        put :update, :id => @event.id, :nurse_id => @nurse.id, :event => @event_attr
#        @event.reload
#        response.should redirect_to(nurse_calendar_index_path(@nurse, :month => @event.start_at.month, :year => @event.start_at.year))
#      end
#
#      it 'should not allow an assignment of name' do
#        @event_attr[:name] = "New Name"
#        put :update, :id => @event.id, :nurse_id => @nurse.id, :event => @event_attr
#        assigns(:event).name.should_not == "New Name"
#      end
#
#      it 'should not allow an assignment of nurse_id' do
#        @event_attr[:nurse_id] = (@nurse.id + 1).to_s
#        put :update, :id => @event.id, :nurse_id => @nurse.id, :event => @event_attr
#        assigns(:event).nurse_id.should_not == @nurse.id + 1
#      end
#
#      it 'should not allow assignement of all_day' do
#        @event_attr[:all_day] = false
#        put :update, :id => @event.id, :nurse_id => @nurse.id, :event => @event_attr
#        assigns(:event).all_day.should_not == false
#      end
#
#    end
#
#    describe "Destroy" do
#
#      it 'should call find from Event' do
#        Event.should_receive(:find_by_id)
#        delete :destroy, :id => @event.id, :nurse_id => @nurse.id
#      end
#
#      it 'should call destroy on the event' do
#        Event.stub(:find_by_id).and_return(@event)
#        @event.should_receive(:destroy)
#        delete :destroy, :id => @event.id, :nurse_id => @nurse.id
#      end
#
#      it 'should redirect' do
#        delete :destroy, :id => @event.id, :nurse_id => @nurse.id
#        response.should redirect_to(nurse_calendar_index_path(@nurse))
#      end
#    end
#  end
end


