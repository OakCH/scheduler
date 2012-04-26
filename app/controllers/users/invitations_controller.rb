class Users::InvitationsController < Devise::InvitationsController
  
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
