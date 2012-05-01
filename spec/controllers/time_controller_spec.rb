require 'spec_helper'

describe TimeController do

  before(:each) do
    @time = Time.find(:all) # should only be one
  end

  describe "Index" do
    it 'should assign the correct time' do
      assigns(:time) { @time }
      get :index
    end
  end

  describe "Update" do
    it 'should change the year' do
      put :update, :time => "2012"
      @time = Time.find(:all)
      assert(@time)
      @time[0] == "2012"
    end

    it 'should redirect to index' do
      put :update, :time => "2012"
      response.should redirect_to(time_index_path)
    end

    it 'should flash with an invalid year' do
      put :update, :time => "jsoefj039tj2340egjf"
      flash[:error].should_not be_empty
    end
  end
end

