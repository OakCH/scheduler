class Unit < ActiveRecord::Base
  has_many :nurses
  has_many :vacation_days
  has_many :events, :through => :nurses

  validates_uniqueness_of :name
  validates_presence_of :name
  def self.shifts
    ['Days', 'PMs', 'Nights']
  end

  def self.names
    self.all.map{|unit| unit.name}
  end

  def self.is_valid_shift(shift)
    return self.shifts.include?(shift)
  end

  def self.is_valid_unit_id(unit_id)
    if not /^[\d]+(\.[\d]+){0,1}$/ === unit_id.to_s
      return false
    else
      return Unit.find_by_id(unit_id) || unit_id == 0
    end
  end
  
  def calculate_max_per_day(shift)
    @max_per = {}
    # find all nurses by unit and shift
    @nurses = Nurse.find_all_by_unit_id_and_shift(self.id, shift)
    # get all nurses' num_weeks_off and add
    @total_weeks_off = 0
    @nurses.each do |nurse|
      @total_weeks_off += nurse.num_weeks_off
    end

    tmp_max_per_day = @total_weeks_off / 46
    @max_per[:year] = tmp_max_per_day.floor

    # minimum of one nurse for any given period
    if @max_per[:year] == 0
      @max_per[:year] = 1
    end

    tmp_max_additional_months = @total_weeks_off - 46*@max_per[:year]
    if tmp_max_additional_months > 0
      calculate_extra_months (tmp_max_additional_months)
    else
      @max_per[:month] = 0
    end
    
    return @max_per
  end

  def calculate_extra_months (num)
    if num <= 12
      @max_per[:month] = 1
      return
    elsif num <= 24
      @max_per[:month] = 2
      return
    elsif num <= 36
      @max_per[:month] = 3
      return
    elsif num <=46
      @max_per[:year] += 1
      return
    end
  end

end
