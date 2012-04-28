class AdminManagerController < ApplicationController
  
  before_filter :authenticate_admin!

  def index
    @admins = Admin.all
  end
  
  def edit
    @admin = Admin.find(params[:id])
  end
  
  def update
    admin = Admin.find(params[:id])
    admin.name = params[:admin][:name]
    admin.email = params[:admin][:email]
    if admin.save
      admin.reload
      flash[:notice] = "#{admin.name} successfully updated."
      redirect_to admins_path
    else
      @admin = admin
      flash[:error] = admin.errors.full_messages.join(' ')
      render 'edit'
    end
  end
  
  def destroy
    admin = Admin.find(params[:id])
    admin.destroy
    redirect_to admins_path
  end

end
