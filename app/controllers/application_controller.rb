class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authenticate_any!
    authenticate_user!
  end
  
  def authenticate_admin!
    authenticate_user!
    permission_denied if !current_admin
  end
  
  def permission_denied
    flash[:error] = 'You cannot access that page'
    redirect_to root_path 
  end
  
  def current_nurse
    if nurse_signed_in?
      @current_nurse ||= Nurse.find_by_id(current_user.personable_id)
    end
  end
  
  def current_admin
    if admin_signed_in?
      @current_admin ||= Admin.find_by_id(current_user.personable_id)
    end
  end 
  
  def nurse_signed_in?
    user_signed_in? and current_user.personable_type == 'Nurse'
  end
  
  def admin_signed_in?
    user_signed_in? and current_user.personable_type == 'Admin'
  end
  
  helper_method :current_nurse, :current_admin
  
end
