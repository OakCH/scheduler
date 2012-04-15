require 'spec_helper'

describe UnitController do
  before(:each) do
    @unit1 = FactoryGirl.create(:unit)
    @unit2 = FactoryGirl.create(:unit)
    @units = [@unit1, @unit2]
  end

  describe "Show" do
    it 'should call find all for units' do
      Unit.should_receive(:find).with(:all).and_return(@units)
      get :index
    end

    it 'should assign units' do
      assigns(:units) { @units }
      get :index
    end
  end

  describe "Create" do
    it 'should add a new unit' do
      name = "ICU"
      @new_unit = FactoryGirl.create(:unit, :name => name)
      post :create, :name => name
      found_unit = Unit.find_by_name(name)
      found_unit.should == @new_unit
    end

    it 'should redirect to the index' do
      name = "ICU"
      post :create, :name => name
      response.should redirect_to(unit_path)
    end
  end

  describe "edit" do
    it 'should call find from Unit' do
      Unit.should_receive(:find_by_id).and_return(@unit1)
      get :edit, :unit_id => @unit1.id
    end

    it 'should assign the given Unit' do
      get :edit, :unit_id => @unit1
      assigns(:unit).id = @unit1.id
    end

    it 'should flash an error if invalid id' do
      get :edit, :unit_id => 'asdfasdfadf'
      flash[:error].should_not be_empty
    end

  end

  describe "update" do
    it 'should flash an error if invalid id' do
      put :update, :unit_id => 'asdfasdfadf'
      flash[:error].should_not be_empty
    end

    it 'should change the name of a unit' do
      new_name = "ICU"
      id = @unit1.id
      put :update, :unit_id => id, :new_name => new_name
      unit = Unit.find_by_id(id)
      unit.name.should == new_name
    end

    it 'should redirect to unit' do
      put :update, :unit_id => @unit1.id, :new_name => "sasafrass"
      response.should redirect_to(unit_path)
    end
  end

  describe 'Destroy' do
    it 'should call find from unit' do
      Unit.should_receive(:find_by_id).and_return(@unit1)
      delete :destroy, :unit_id => @unit1.id
    end

    it 'should flash if there is an invalid unit' do
      delete :destroy, :unit_id => "sasafrass"
      flash[:error].should_not be_empty
    end

    it 'should call destroy on unit' do
      Unit.stub(:find_by_id).and_return(@unit1)
      @unit1.should_receive(:destroy)
      delete :destroy, :unit_id => @unit1.id
    end

    it 'should redirect' do
      delete :destroy, :unit_id => @unit1.id
      response.should redirect_to(unit_path)
    end
  end

end

