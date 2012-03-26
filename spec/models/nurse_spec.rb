require 'spec_helper'

def bulk_nurse_helper(unit,shift,num)
  for x in 1..num
    nurse = FactoryGirl.create(:nurse,:unit=>unit,:shift=>shift)
    FactoryGirl.create(:event,:nurse=>nurse)
  end
  return nurse
end

describe Nurse do
  describe "get all nurses by unit and id" do 
    before(:each) do
      @unit1 = FactoryGirl.create(:unit)
      @unit2 = FactoryGirl.create(:unit)
    end
    it 'should give a string of all nurse ids for one shift and unit' do
      nurse1 = bulk_nurse_helper(@unit1,'PMs',1)
      nurse2 = bulk_nurse_helper(@unit1,'PMs',1)
      nurse3 = bulk_nurse_helper(@unit2,'PMs',1)
      Nurse.get_nurse_ids_shift_unit_id('PMs',@unit1.id).should == "(#{nurse1.id},#{nurse2.id})"
    end
    describe "more than one unit and shift among many nurses" do
      before(:each) do
        bulk_nurse_helper(@unit1,'PMs',2)
        bulk_nurse_helper(@unit2,'Days',3)
      end
      it 'should give a string of all the nurse ids in a certain shift and unit' do
        nurse_string = Nurse.get_nurse_ids_shift_unit_id('Days',@unit2.id)
        nurse_string[1,nurse_string.length-2].split(",").length.should == 3
      end
      it 'should not return the same string of nurse ids if those nurse have different shift and unit' do
        nurse_string = Nurse.get_nurse_ids_shift_unit_id('PMs',@unit1.id)
        nurse_string2 = Nurse.get_nurse_ids_shift_unit_id('Days',@unit2.id)
        nurse_string.should_not == nurse_string2
      end
    end
    it 'should return nil if there are no nurse ids for a certain shift and unit' do
      bulk_nurse_helper(@unit2,'PMs',3)
      nurse_string = Nurse.get_nurse_ids_shift_unit_id('Nights',@unit2.id).should be_nil
    end
  end
end
