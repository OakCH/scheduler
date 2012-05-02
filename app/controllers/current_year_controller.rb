class CurrentYearController < ApplicationController

  before_filter :authenticate_admin!

  def index
    @current_year = CurrentYear.find(:all).first
  end

  def update
    # hack hack hack hack
    new_year = params[:year]
    current_year = CurrentYear.find(:all)
    begin
      current_year.first.year = Integer(new_year)
    rescue
      flash[:error] = "Invalid year entered"
    end
    unless current_year[0].save
      flash[:error] = "Problem changing current year."
    end
    redirect_to(current_year_index_path)
  end

end
