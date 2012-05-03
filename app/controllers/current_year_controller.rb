class CurrentYearController < ApplicationController

  before_filter :authenticate_admin!

  def index
    if CurrentYear.first
      @current_year = CurrentYear.first.year
    end
  end

  def update
    # hack hack hack hack
    new_year = params[:year]
    current_year = CurrentYear.first
    begin
      if current_year
        current_year.year = Integer(new_year)
      else
        current_year = CurrentYear.new(:year => new_year)
      end
    rescue
      flash[:error] = "Invalid year entered"
    end
    unless current_year.save
      flash[:error] = "Problem changing current year."
    end
    redirect_to(current_year_index_path)
  end

end
