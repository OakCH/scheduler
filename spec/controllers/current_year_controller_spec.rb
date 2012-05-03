require 'spec_helper'

describe CurrentYearController do

  before(:each) do
    FactoryGirl.create(:current_year, :year => 2010)
    @time = CurrentYear.find(:all).first # should only be one
  end

  before(:all) do
    CurrentYearController.skip_before_filter(:authenticate_admin!)
  end

  describe "Index" do
    it 'should assign the correct time' do
      assigns(:current_year) { @time }
      get :index
    end
  end

  describe "Update" do
    it 'should change the year' do
      put :update, :year => "2012"
      @time = CurrentYear.find(:all).first
      assert(@time)
      @time.year.should == 2012
    end

    it 'should redirect to index' do
      put :update, :year => "2012"
      response.should redirect_to(current_year_index_path)
    end

    it 'should flash with an invalid year' do
      put :update, :year => "jsoefj039tj2340egjf"
      flash[:error].should_not be_empty
    end
  end
end

