class AdminController < ApplicationController
  
  before_filter :authenticate_admin!
  
  # attr_reader :unit, :shift
  
  def rules
    @units = Unit.names
    @shifts = Unit.shifts
    if flash[:error] == nil
      flash[:error] = []
    end
    
    if params[:admin]
      getNextParams
      if @unit_obj && @shift
        @readyToShow = true
      end
    end
    
    if params[:commit] == 'Next'
      valid = verify_shift_and_unit
      if !valid
        @readyToShow = false
      else
        max_per = @unit_obj.calculate_max_per_day(@shift)
        @num_months = max_per[:month]
      end
      flash.keep
      redirect_to :admin => {:shift => @shift, :unit => @unit} and return
    end
    
    if params[:commit] == 'Done'
      # put into the unit_and_shift db
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
        @nurses = @unit_obj.nurses.where(:shift => @shift).order(:seniority)
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
  
end
