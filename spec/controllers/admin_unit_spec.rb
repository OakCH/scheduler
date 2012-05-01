# this is basically CRUD on admin_units
require 'spec_helper'

describe AdminUnitController do
  before(:each) do
    @admin = FactoryGirl.create(:admin)
    @unit1 = FactoryGirl.create(:unit)
    @unit2 = FactoryGirl.create(:unit)
    @unit3 = FactoryGirl.create(:unit)
    @admin.units << @unit1
    @admin.units << @unit2
    @admin.units << @unit3
    @admin.save
    controller.stub(:current_admin).and_return(@admin)
  end

  before(:all) do
    AdminUnitController.skip_before_filter(:authenticate_admin!)
  end

  describe "index" do

    it 'should get all units from an admin' do
      controller.current_admin.should_receive(:units)
      get :index
    end

    it 'should assign admin_units from admin' do
      assigns(:admin_units) { @admin.units }
      get :index
    end

    it 'should assign units from all units' do
      assigns(:units) { Unit.find(:all) }
      get :index
    end


  end

  describe "update" do
    it 'should redirect to index' do
      put :update
      response.should redirect_to(admins_units_index_path)
    end

    it 'add unit to admin' do
      @unit4 = FactoryGirl.create(:unit)
      new_units = (@admin.units + [@unit4]).map { |u| u.name }
      put :update, :units => { new_units[0] => true, new_units[1] => true,
                               new_units[2] => true, new_units[3] => true }
      @admin.units.length.should == 4
    end

    it 'errors trying to add nonexistent units' do
      put :update, :units => { "aojoiajwef230f240efrrf" => true }
      flash[:error].should_not be_empty
    end

    it 'remove unit from admin' do
      new_units = @admin.units[0..3].map { |u| u.name }
      put :update, :units => {
        new_units[0] => true, new_units[1] => true,
        new_units[2] => false
      }
      @admin.units.length.should == 2
    end

    it 'errors trying to remove a nonexistent unit' do
      put :update, :units => { "sjoeifjosejf" => false }
      flash[:error].should_not be_empty
    end

    it 'remove unit and add another to admin' do
      other_unit = FactoryGirl.create(:unit)
      temp_unit = @admin.units[2]
      new_units = (@admin.units[0..3] + [other_unit]).map { |u| u.name }
      put :update, :units => {
        new_units[0] => true, new_units[1] => true,
        new_units[2] => false, new_units[3] => true,
      }

      @admin.units.length.should == 3
      @admin.units.should include(other_unit)
      @admin.units.should_not include(temp_unit)
    end
  end
end

