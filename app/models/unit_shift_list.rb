class Uniti_Shift_list < ActiveRecord::Base
  has_many :nurses, :order => 'position'
  def sort
    @unit_shift_list = Unit.find(params[:id])
    @unit_shift_list.nurses.each do | f |
      f.position = params["unit-shift-list"].index(f.id.to_s)+1
      f.save
    end
  end
end
