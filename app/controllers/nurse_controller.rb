class NurseController < ApplicationController
  before_filter :authenticate_admin!
  
  # attr_reader :unit, :shift
  def edit
  end

  def update
  end
  def new
  end
  def create
  end
  def destroy
  end

  def index
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
      if @unit == nil
        flash[:error] << "Forgot to specify unit"
        @readyToUpload = false
      end
      if @unit != nil && @unit_obj == nil
        flash[:error] << 'Invalid unit'
        @readyToUpload = false
      end
      if @shift == nil
        flash[:error] << "Invalid shift"
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

end
