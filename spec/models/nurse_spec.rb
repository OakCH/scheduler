require 'spec_helper'
require 'date'

describe Nurse do
  before(:each) do
    @unit1 = FactoryGirl.create(:unit)
    @unit2 = FactoryGirl.create(:unit)
    for x in 1..1
      nurse = FactoryGirl.create(:nurse,:unit=>@unit1,:shift=>'Days')
      FactoryGirl.create(:event, :nurse=>nurse)
    end
    for x in 1..2
      nurse = FactoryGirl.create(:nurse,:unit=>@unit1,:shift=>'PMs')
      FactoryGirl.create(:event, :nurse=>nurse)
    end
    for x in 1..3
      nurse = FactoryGirl.create(:nurse,:unit=>@unit2,:shift=>'Days')
      FactoryGirl.create(:event, :nurse=>nurse)
    end
    for x in 1..4
      nurse = FactoryGirl.create(:nurse,:unit=>@unit2,:shift=>'PMs')
      FactoryGirl.create(:event, :nurse=>nurse)
    end
  end
  it 'should give a string of all the nurse ids in a certain shift and unit' do
    nurse_temp = Nurse.find(:all, :conditions => {:shift=>'Days', :unit_id => @unit2.id}).length.should == 3
    nurse_string = Nurse.get_nurse_ids_shift_unit_id('Days',@unit2.id)

    nurse_string[1,nurse_string.length-2].split(",").length.should == 3
  end
  it 'should not give a string of nurse ids in a different shift and unit' do
    nurse_string = Nurse.get_nurse_ids_shift_unit_id('Days',@unit2.id)
    nurse_string2 = Nurse.get_nurse_ids_shift_unit_id('PMs',@unit1.id)
    nurse_string.should_not equal(nurse_string2)
  end
  it 'should return nil if there are no nurse ids for a certain shift and unit' do
    nurse_string = Nurse.get_nurse_ids_shift_unit_id('Nights',@unit2.id).should be_nil
  end
end
