require 'spec_helper'

describe UnitController do
  before(:each) do
    @unit1 = FactoryGirl.create(:unit)
    @unit2 = FactoryGirl.create(:unit)
    @units = [@unit1, @unit2]
  end

  before(:all) do
    UnitController.skip_before_filter(:authenticate_admin!)
  end

  describe "Index" do
    it 'should call find all for units' do
      Unit.should_receive(:find).with(:all).and_return(@units)
      get :index
    end

    it 'should assign units' do
      assigns(:units) { @units }
      get :index
    end
  end

  describe "Show" do
    it 'should redirect to the main index' do
      @new_unit = FactoryGirl.create(:unit)
      get :show, :id => @new_unit.id
      response.should redirect_to(units_path)
    end
  end

  describe "Create" do
    context "Successfully add a new unit" do
      it 'should add a new unit' do
        name = "ICU"
        @new_unit = FactoryGirl.create(:unit, :name => name)
        post :create, :unit => { :name => name }
        found_unit = Unit.find_by_name(name)
        found_unit.name.should == @new_unit.name
      end

      it 'should redirect to the index' do
        name = "ICU"
        post :create, :unit => { :name => name }
        response.should redirect_to(units_path)
      end
    end

    context "Fail to add a new unit" do
      it 'should not update if there is a taken name' do
        name = @unit1.name
        post :create, :unit => { :name => name }
        flash[:error].should_not be_empty
      end
    end
  end

  describe "edit" do
      it 'should assign the given Unit' do
      get :edit, :id => @unit1
      assigns(:unit).id = @unit1.id
    end

    context "Given invalid id" do
      it 'should flash an error if invalid id' do
        get :edit, :id => 'asdfasdfadf'
        flash[:error].should_not be_empty
      end

      it 'should redirect to unit path' do
        id = 'ajsoidfjef'
        get :edit, :id => id
        response.should redirect_to(units_path)
      end
    end
  end

  describe "update" do
    context "succesfully edit unit" do
      it 'should call find from Unit' do
        name = "dummyname"
        Unit.should_receive(:find_by_id).and_return(@unit1)
        post :update, :id => @unit1.id, :unit => { :name => name }
      end

      it 'should change the name of a unit' do
        new_name = "ICU"
        id = @unit1.id
        post :update, :id => id, :unit => { :name => new_name }
        unit = Unit.find_by_id(id)
        unit.name.should == new_name
      end

      it 'should redirect to unit' do
        post :update, :id => @unit1.id, :unit => { :name => "sasafrass" }
        response.should redirect_to(units_path)
      end
    end

    context "fail to edit unit" do
      it 'should fail when you edit the name to another name' do
        name = @unit1.name
        post :update, :id => @unit2.id, :unit => { :name => name }
        flash[:error].should_not be_empty
      end

      it 'should flash an error if invalid id' do
        name = "fake name"
        post :update, :id => 'asdfasdfadf', :unit => { :name => name }
        flash[:error].should_not be_empty
      end
    end
  end


  describe 'Destroy' do
    it 'should call find from unit' do
      Unit.should_receive(:find_by_id).and_return(@unit1)
      delete :destroy, :id => @unit1.id
    end

    it 'should flash if there is an invalid unit' do
      delete :destroy, :id => "sasafrass"
      flash[:error].should_not be_empty
    end

    it 'should call destroy on unit' do
      Unit.stub(:find_by_id).and_return(@unit1)
      @unit1.should_receive(:destroy)
      delete :destroy, :id => @unit1.id
    end

    it 'should redirect' do
      delete :destroy, :id => @unit1.id
      response.should redirect_to(units_path)
    end
  end

end

