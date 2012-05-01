class AdminUnitController < ApplicationController

  before_filter :authenticate_admin!

  def index
    units = Unit.find(:all)
    admin_units = current_admin.units

    @units = Hash.new
    units.each do |unit|
      @units[unit] = !admin_units.nil? && (admin_units.include? unit)
    end
  end

  def update

    unit_names = params[:units]

    unit_names ||= []

    # Find units with name given
    units = []
    unit_names.each do | name, val |
      puts "JOAIWJDOAWIJDOWAJD"
      unit = Unit.find_by_name(name)
      if not unit
        flash[:error] = "One or more units could not be added or removed."
        break
      elsif val == "1"

        units << unit
      end
    end

    current_admin.units = units

    unless current_admin.save
      flash[:error] += "Failed to change units."
    end

    flash[:notice] = "Units association changed."
    redirect_to(admin_unit_index_path)
  end

end
