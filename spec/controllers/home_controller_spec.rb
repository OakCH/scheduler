require 'spec_helper'

describe HomeController do
  
  before do
    @nurse = FactoryGirl.create(:nurse)
    @admin = FactoryGirl.create(:admin)
  end
  
  it 'should redirect to the nurse calendar if a nurse is signed in' do
    controller.stub(:nurse_signed_in?).and_return(true)
    controller.stub(:current_nurse).and_return(@nurse)
    get :index
    response.should redirect_to nurse_calendar_index_path(@nurse)
  end
  
  it 'should redirect to the admin calendar if an admin is signed in' do
    controller.stub(:admin_signed_in?).and_return(true)
    controller.stub(:current_admin).and_return(@admin)
    get :index
    response.should redirect_to admin_calendar_path
  end
  
  it 'should redirect to sign in page if no one is signed in' do
    get :index
    response.should redirect_to new_user_session_path
  end
end
