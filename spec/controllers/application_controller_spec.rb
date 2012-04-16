require 'spec_helper'

describe ApplicationController do
  
  before do
    @nurse = FactoryGirl.create(:nurse)
    @admin = FactoryGirl.create(:admin)
  end
  
  describe 'authenticate_any!' do
    it 'should call the devise authenticate_user!' do
      controller.should_receive(:authenticate_user!)
      controller.authenticate_any!
    end
  end
  
  describe 'authenticate_admin!' do
    before do 
      controller.stub(:authenticate_user!)
    end
    
    it 'should call the devise authenticate_user!' do
      controller.should_receive(:authenticate_user!)
      controller.authenticate_any!
    end
    
    it 'should not set permission denied if an admin authenticated' do
      controller.stub(:current_admin).and_return(true)
      controller.should_not_receive(:permission_denied)
      controller.authenticate_admin!
    end
    
    it 'should set permission denied if a nurse authenticated' do
      controller.stub(:current_admin).and_return(false)
      controller.should_receive(:permission_denied)
      controller.authenticate_admin!
    end
  end
  
  describe 'permission denied' do
    before { controller.stub(:redirect_to) }
    
    it 'should set a flash error indicated permission denied' do
      controller.permission_denied
      flash[:error].should == 'You cannot access that page'
    end
    
    it 'should redirect to the nurse calendar index page' do
      controller.should_receive(:redirect_to).with(root_path)
      controller.permission_denied
    end
  end 
  
  describe 'current admin' do
    it 'should return the current admin if one is signed in' do
      controller.stub(:user_signed_in?).and_return(true)
      controller.stub(:current_user).and_return(@admin)
      controller.current_admin.should == @admin
    end
    
    it 'should be nil if a nurse is signed in' do
      controller.stub(:user_signed_in?).and_return(true)
      controller.stub(:current_user).and_return(@nurse)
      controller.current_admin.should be_nil
    end
    
    it 'should be nil if no one is signed in' do
      controller.stub(:user_signed_in?).and_return(false)
      controller.stub(:current_user)
      controller.current_admin.should be_nil
    end
  end
  
  describe 'current nurse' do
    it 'should return the current nurse if one is signed in' do
      controller.stub(:user_signed_in?).and_return(true)
      controller.stub(:current_user).and_return(@nurse)
      controller.current_nurse.should == @nurse
    end
    
    it 'should be nil if a admin is signed in' do
      controller.stub(:user_signed_in?).and_return(true)
      controller.stub(:current_user).and_return(@admin)
      controller.current_nurse.should be_nil
    end
    
    it 'should be nil if no one is signed in' do
      controller.stub(:user_signed_in?).and_return(false)
      controller.stub(:current_user)
      controller.current_nurse.should be_nil
    end
  end
end
