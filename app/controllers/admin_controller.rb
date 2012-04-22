class AdminController < ApplicationController
  
  before_filter :authenticate_admin!
  
  def rules
    @units = Unit.names
    @shifts = Unit.shifts
    @month_names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    if flash[:error] == nil
      flash[:error] = []
    end
    
    if params[:admin]
      getNextParams
      if @unit_obj && @shift
        @readyToShow = true

        max_per = @unit_obj.calculate_max_per_day(@unit_obj.id, @shift)
        @num_months = max_per[:month]
        # list of starting months for additional segments
        # used in the view to pre-select the drop-down
        @start_months = set_up_start_months(@unit_obj.id, @shift, @num_months)
        @max_holidays = set_up_max_holidays(@unit_obj.id, @shift)
      end
    end
    
    if params[:commit] == 'Next'
      valid = verify_shift_and_unit
      if !valid
        @readyToShow = false
      end
      flash.keep
      redirect_to :admin => {:shift => @shift, :unit => @unit} and return
    end
    
    if params[:commit] == 'Done with Segments'
      # put into the unit_and_shift db
      # check if need to update
      @records = UnitAndShift.get_add_month_objs(@unit_obj.id, @shift)
      if @records.empty?
        create_records(@unit_obj, @shift, @num_months, @month_names)
        @start_months = set_up_start_months(@unit_obj.id, @shift, @num_months)
      else
        update_records(@records, @month_names)
        @start_months = set_up_start_months(@unit_obj.id, @shift, @num_months)
      end
      flash[:error] = 'Your changes have been saved'
      flash.keep
      redirect_to :admin => {:shift => @shift, :unit => @unit} and return
    end
    
    if params[:commit] == 'Done with Holidays'
      @max_holidays = params[:admin][:holiday]
      if !check_holiday_validity(@max_holidays)
        flash[:error] << 'Holiday input invalid'
        flash.keep
        redirect_to :admin => {:shift => @shift, :unit => @unit} and return
      end
      @max_holidays = @max_holidays.to_i
      @holiday = UnitAndShift.get_holiday_obj(@unit_obj.id, @shift)
      if @holiday != nil
        @holiday.update_attributes!(:holiday => @max_holidays)
      else
        holiday_obj = UnitAndShift.new(:unit => @unit_obj, :shift => @shift, :holiday => @max_holidays)
        holiday_obj.save
      end
      flash[:error] << 'You have updated the holiday nurse limit.'
      flash.keep
      redirect_to :admin => {:shift => @shift, :unit => @unit} and return
    end
  end
  
  def upload
    @units = Unit.names
    @shifts = Unit.shifts
    if flash[:error] == nil
      flash[:error] = []
    end
    
    if params[:admin]
      getNextParams
      if (@unit_obj && @shift)
        @readyToUpload = true
        @nurses = @unit_obj.nurses.where(:shift => @shift).order(:position)
      end
    end
    
    if params[:commit] == 'Show'
      valid = verify_shift_and_unit
      if !valid
        @readyToUpload = false
      end
      flash.keep
      redirect_to :admin => {:shift => @shift, :unit => @unit} and return
    end
    
    if params[:commit] == 'Upload'
      @file = params[:admin][:upload]
      if @file
        copyFile(@file)
        Nurse.replace_from_spreadsheet(Rails.root.join('tmp', @file.original_filename).to_path, @unit_obj, @shift)
        flash[:error].concat(Nurse.parsing_errors[:messages])
        deleteFile(@file)
      else 
        flash[:error] << "Please select a file"
      end
      flash.keep
      redirect_to :admin => {:shift => @shift, :unit => @unit} and return
    end
  end
  
  private
  
  def copyFile(file)
    File.open(Rails.root.join('tmp', file.original_filename), 'wb') do |f|
      f.write(file.read)
    end
  end
  
  def deleteFile(file)
    File.delete(Rails.root.join('tmp', file.original_filename))
  end
  
  def getNextParams
    @unit = params[:admin][:unit]
    if @unit
      @unit_obj = Unit.find_by_name(@unit)
    end
    @shift = params[:admin][:shift]
    if @shift != nil && (@shifts == nil || !@shifts.include?(@shift))
      @shift = nil
    end
  end
  
  def verify_shift_and_unit
    valid = true
    if @unit == nil
      flash[:error] << "Forgot to specify unit"
      valid = false
    end
    if @unit != nil && @unit_obj == nil
      flash[:error] << 'Invalid unit'
      valid = false
    end
    if @shift == nil
      flash[:error] << "Invalid shift"
      valid = false
    end
    return valid
  end
  
  def set_up_start_months(unit_id, shift, num_months)
    @start_months = UnitAndShift.get_additional_months(unit_id, shift)
    if @start_months.empty?
      while num_months > 0 do
        @start_months << 1
        num_months -= 1
      end
    end
    return @start_months
  end
  
  def set_up_max_holidays(unit_id, shift)
    obj = UnitAndShift.get_holiday_obj(unit_id, shift)
    if obj != nil
      return obj.holiday
    else
      return "N/A"
    end
  end
  
  def create_records(unit, shift, num_months, month_names)
    i = 1
    while i <= num_months do
      month = month_names.index(params[:admin]["seg#{i}"]) + 1
      add_month = UnitAndShift.new(:unit => unit, :shift => shift, :additional_month => month)
      add_month.save
      i += 1
    end
  end
  
  def update_records(records, month_names)
    i = 1
    records.each do |r|
      month = month_names.index(params[:admin]["seg#{i}"]) + 1
      r.update_attributes!(:additional_month => month)
      i += 1
    end
  end
  
  def check_holiday_validity(input)
    return /\d/.match(input) && input.to_i >= 0
  end
end
