class NurseController < ApplicationController
  before_filter :authenticate_admin!

  def new
    @shifts = Unit.shifts
    @units = Unit.names
  end

  def create
    unit_name = params[:nurse][:unit]
    params[:nurse][:unit] = Unit.find_by_name(params[:nurse][:unit])
    params[:nurse][:position] = params[:nurse][:unit].nurses.find(:first, :order => "id desc").id + 1
    errors = invalid_inputs(params[:nurse])
    if not errors.empty?
      @nurse = Nurse.create!(params[:nurse])
      flash[:notice] = "#{@nurse.name} was successfully added."
      redirect_to nurse_manager_index_path(:admin => {:shift => params[:nurse][:shift], :unit => unit_name}) and return
    else
      flash[:error] = errors
      render :new
    end
  end

  def edit
    @nurse = Nurse.find params[:id]
    @nurse[:unit] = Unit.find_by_id(@nurse[:unit_id]).name
    @shifts = Unit.shifts
    @units = Unit.names
  end

  def update
    @nurse = Nurse.find params[:id]
    @shifts = Unit.shifts
    @units = Unit.names
    unit_name = params[:nurse][:unit]
    params[:nurse][:unit] = Unit.find_by_name(params[:nurse][:unit])
    @nurse.update_attributes!(params[:nurse])
    flash[:notice] = "#{@nurse.name}'s information was successfully updated."
    redirect_to nurse_manager_index_path(:admin => {:shift => params[:nurse][:shift], :unit => unit_name}) and return
  end

  def destroy
    unit_name = params[:nurse][:unit]
    @nurse = Nurse.find(params[:id])
    @nurse.destroy
    flash[:notice] = "#{@nurse.name} was removed from the system."
    redirect_to nurse_manager_index_path(:admin => {:shift => params[:nurse][:shift], :unit => unit_name}) and return
  end

  def invalid_inputs(inputs)
    errors = []
    errors << "Please input a valid name." if not inputs[:name] or inputs[:name].strip.empty?
    errors << "Please input a valid email." if not inputs[:email] or inputs[:email].strip.empty?
    if not inputs[:num_weeks_off] or inputs[:num_weeks_off].strip.empty? or inputs[:num_weeks_off].strip.is_i?
      errors << "Please input a valid number of vacation weeks."
    end
    if inputs[:years_worked] and (inputs[:years_worked].strip.empty? or inputs[:years_worked].strip.is_i?)
      errors << "Please input a valid number of years worked."    
    end
    if inputs[:email] and User.find_by_email(inputs[:email].strip)
      errors << "This email is already in use. Please check to see if you have already added this nurse to the system."
    end
    errors
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

end

class String
  def is_i?
    !!(self =~ /^[-+]?[0-9]+$/)
  end
end
