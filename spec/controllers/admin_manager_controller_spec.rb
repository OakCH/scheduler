require 'spec_helper'

describe AdminManagerController do

  before(:all) do
    AdminManagerController.skip_before_filter(:authenticate_admin!)
  end

  before(:each) do
    @admin = FactoryGirl.create(:admin)
  end
  
  describe 'index' do
    it 'should set a variable for a list of all admins in the database' do
      get :index
      assigns[:admins].should == [@admin]
    end
  end
  
  describe 'edit' do
    it 'should set a variable corresponding to the admin being edited' do
      get :edit, :id => @admin.id
      assigns[:admin].should == @admin
    end
  end
  
  describe 'update' do
    
    context 'with valid update information' do
      it 'should allow updating of an admin email' do
        put :update, :id => @admin.id, :admin => { :name => @admin.name, :email => 'new_email@mail.com' }
        @admin.reload.email.should == 'new_email@mail.com'
      end
      it 'should allow updating of an admin name' do
        put :update, :id => @admin.id, :admin => { :name => 'new_name', :email => @admin.email }
        @admin.reload.name.should == 'new_name'
      end
    end
    
    context 'with invalid update information' do
      it 'should not allow a change of email without name' do
        orig_mail = @admin.email
        put :update, :id => @admin.id, :admin => { :email => 'new_email@mail.com' }
        @admin.reload.email.should == orig_mail
      end
      it 'should not allow a change of name without email' do
        orig_name = @admin.name
        put :update, :id => @admin.id, :admin => { :name => 'new_name' }
        @admin.reload.name.should == orig_name
      end
      it 'should set a flash indicating that the update failed' do
        put :update, :id => @admin.id, :admin => { :name => 'new_name' }
        flash[:error].should == 'User email can\'t be blank'
      end
      it 'should render the edit page' do
        put :update, :id => @admin.id, :admin => { :name => 'new_name' }
        response.should render_template('edit')
      end
    end
  end
  
  describe 'destroy' do
    it 'should remove the admin from the database' do
      delete :destroy, :id => @admin.id
      Admin.find_by_id(@admin.id).should == nil
    end
    it 'should redirect to the list of admins' do
      delete :destroy, :id => @admin.id
      response.should redirect_to(admins_path)
    end
    it 'should set a flash indicating the admin has been deleted' do
      delete :destroy, :id => @admin.id
      flash[:notice].should == "#{@admin.name} has been deleted."
    end
  end

end
