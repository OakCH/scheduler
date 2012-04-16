class UnitAndShift < ActiveRecord::Base
  validates_presence_of :shift
  validates_presence_of :additional_month
  belongs_to :unit
  
  def self.get_additional_months(unit_id, shift)
    @records = UnitAndShift.find_all_by_unit_id_and_shift(unit_id, shift)
    @months = []
    @records.each do |record|
      start_month = record.additional_month
      @months << start_month
      @months << (start_month + 1) % 12
      @months << (start_month + 2) % 12
    end
    return @months
  end
end