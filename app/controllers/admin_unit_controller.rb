class AdminUnitController < ApplicationController

  before_filter :authenticate_admin!

  def index
    @units = Unit.find(:all)
    @admin_units = current_admin.units
  end

  def update
    unit_names = params[:units]

    unit_names ||= []

    # Find units with name given
    units = []
    unit_names.each do | name, val |
      unit = Unit.find_by_name(name)
      if not unit
        flash[:error] = "One or more units could not be added or removed."
        break
      elsif val
        units << unit
      end
    end

    current_admin.units = units

    if not current_admin.save
      flash[:error] += "Failed to change units."
    end

    redirect_to(admins_units_index_path)
  end

end
