class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_any!
    return if admin_signed_in?
    authenticate_nurse!
  end
   
end
