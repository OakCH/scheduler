class Users::InvitationsController < Devise::InvitationsController
  
  def new
    build_resource
    render 'admin_manager/new_admin', :layout => 'application'
  end
  
  def create
    admin = Admin.new(params[:user])
    self.resource = admin.user
    if admin.save
      admin.user.invite!
      set_flash_message :notice, :send_instructions, :email => admin.email
      respond_with resource, :location => admins_path
    else
      render 'admin_manager/new_admin', :layout => 'application'
    end
  end
  
  def edit
    if params[:invitation_token] && self.resource = resource_class.to_adapter.find_first( :invitation_token => params[:invitation_token] )
      @email = self.resource.email
      render :edit
    else
      set_flash_message(:alert, :invitation_token_invalid)
      redirect_to after_sign_out_path_for(resource_name)
    end
  end
  
end
