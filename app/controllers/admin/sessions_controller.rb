class Admin::SessionsController < Devise::SessionsController

  def create
    logout_nurse
    super
  end
  
  def logout_nurse
    sign_out :nurse
  end
  
end
