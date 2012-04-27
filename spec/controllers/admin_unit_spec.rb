# this is basically CRUD on admin_units

require 'sepc_helper'

describe AdminUnitController do
  before(:all) do
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

  describe "index" do

    it 'should get all units from an admin' do
      Unit.should_receive(:units)
      get :index
    end

    it 'should assign units from admin' do
      assigns(:units) { @admin.units }
      get :index
    end
  end

  describe "update" do
    it 'add unit to admin' do
      @unit4 = FactoryGirl.create(:unit)
      new_units = @admin.units + [@unit4]
      put :update, :units => { new_units.map { |u|.name } }
      @admin.units.length.should == 4
    end

    it 'remove unit to admin' do
      new_units = @admin.units[0..2]
      put :update, :units => { new_units.map { |u|.name } }
      @admin.units.length.should == 3
    end

    it 'remove unit and add another to admin' do
      other_unit = FactoryGirl.create(:unit)
      new_units = @admin.units[0..2] + [other_unit]
      put :update, :units => { new_units.map { |u|.name } }
      @admin.units.length.should == 4
      @admin.units.should include(other_unit)
      @admin.units.should_not include(@admin.units[2])
    end
  end
end
