class UnitAndShift < ActiveRecord::Base
  validates_presence_of :shift
  belongs_to :unit, :dependent => :destroy
  
  # returns a list of all starting months for each segment
  # list.length == num_segments
  def self.get_additional_months(unit_id, shift)
    @records = UnitAndShift.find_all_by_unit_id_and_shift(unit_id, shift)
    @start_months = []
    if @records != []
      @records.each do |r|
        if r.additional_month != nil
          @start_months << r.additional_month
        end
      end
    end
    return @start_months
  end
  
  def self.get_holiday_obj(unit_id, shift)
    @records = UnitAndShift.find_all_by_unit_id_and_shift(unit_id, shift)
    @holiday_obj = nil
    if @records != []
      @records.each do |record|
        if record.holiday != nil
          @holiday_obj = record
        end
      end
    end
    return @holiday_obj
  end
  
  def self.get_add_month_objs(unit_id, shift)
    @records = UnitAndShift.find_all_by_unit_id_and_shift(unit_id, shift)
    @rtn_records = []
    if !@records.empty?
      @records.each do |r|
        if r.additional_month != nil
          @rtn_records << r
        end
      end
    end
    return @rtn_records
  end
end