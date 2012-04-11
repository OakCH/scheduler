class Nurse::SessionsController < Devise::SessionsController
  
  def create
    logout_admin
    super
  end
  
  def logout_admin
    sign_out :admin
  end

end
