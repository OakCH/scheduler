class UnitController < ApplicationController
  def index
    @units = Unit.find(:all)
  end

  def new
  end

  def create
    name = params[:name]
    new_unit = Unit.new(:name => name)
    if not new_unit.save then
      flash[:error] = "Unit name is taken: #{new_unit.errors.full_messages.join(' ')}"
    end
    redirect_to units_path
  end

  def edit
    @unit = Unit.find_by_id(params[:id])
    if not @unit
      flash[:error] = "Unit not found"
      redirect_to units_path
    end
  end

  def update
    id = params[:id]
    name = params[:new_name]
    unit = Unit.find_by_id(id)
    if not unit
      flash[:error] = "The unit you are trying to update could not be found."
      redirect_to units_path
      return
    end
    unit.name = name
    if not unit.save
      flash[:error] = "The update failed for the following reasons: #{unit.errors.full_messages.join(' ')}"
      redirect_to units_path
    end
  end

  def destroy
    id = params[:id]
    unit = Unit.find_by_id(id)
    if unit == nil
      flash[:error] = "The unit you are trying to delete could not be found"
      redirect_to units_path
      return
    end
    if not unit.destroy
      flash[:error] = "The unit could not be deleted"
    else
      flash[:notice] = "The unit has been deleted"
    end
    redirect_to units_path
  end
end
