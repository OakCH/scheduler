require 'spec_helper'

describe Users::InvitationsController do
  
  before(:all) do
    Users::InvitationsController.skip_before_filter(:authenticate_inviter!)
    Users::InvitationsController.skip_before_filter(:has_invitations_left?)
  end
  
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @admin = FactoryGirl.create(:admin)
  end
  
  describe 'new' do
    it 'should render the new admin page' do
      get :new
      response.should render_template('admin_manager/new_admin', :layout => 'application')
    end
  end
  
  describe 'create' do
    before { @params = { "name" => 'new_name', "email" => 'new_mail@mail.com' } }
    
    it 'should create a new admin' do
      Admin.should_receive(:new).with(@params).and_return(@admin)
      post :create, :user => @params
    end
    it 'should invite the new admin created' do
      Admin.stub(:new).and_return(@admin)
      @admin.user.should_receive(:invite!)
      post :create
    end
    it 'should redirect to the list of admins' do
      post :create, :user => @params
      response.should redirect_to(admins_path)
    end
    it 'should set a flash message informing that the invitation has been sent' do
      controller.should_receive(:set_flash_message).with(:notice, :send_instructions, :email => @params["email"])
      post :create, :user => @params
    end
    it 'should render the new admin page upon validation errors' do
      post :create
      response.should render_template('admin_manager/new_admin', :layout => 'application')
    end
  end
  
  describe 'edit' do
    context 'invalid invitation token' do
      it 'should redirect to the login page if a valid invitation token is not present' do
        get :edit
        response.should redirect_to :root
      end
      it 'should set a flash alerting about the invalid token' do
        controller.should_receive(:set_flash_message).with(:alert, :invitation_token_invalid)
        get :edit
      end
    end
    
    context 'valid invitation token' do
      before { @admin.user.invite! }
      it 'should set an instance variable of email to the user\'s current email' do
        get :edit, :invitation_token => @admin.invitation_token
        assigns[:email].should == @admin.email
      end
      it 'should render the edit page' do
        get :edit, :invitation_token => @admin.invitation_token
        response.should render_template('edit')
      end
    end
  end
  
end
