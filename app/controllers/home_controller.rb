class HomeController < ApplicationController
  
  def index
    flash.keep
    return redirect_to nurse_calendar_index_path(current_nurse) if nurse_signed_in?
    return redirect_to admin_calendar_path if admin_signed_in?
    redirect_to new_user_session_path
  end
  
end
