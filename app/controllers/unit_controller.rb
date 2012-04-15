class UnitController < ApplicationController
  def index
    @units = Unit.find(:all)
  end

  def new
  end

  def create
    name = params[:name]
    Unit.create(:name => name)
  end

  def edit
  end
end
