class NurseController < ApplicationController
  before_filter :authenticate_any!
  before_filter :authenticate_admin!, :except => ['seniority']

  before_filter :check_nurse_id, :only => ['seniority']

  def new
    @shifts = Unit.shifts
    @units = Unit.names
  end

  def create
    @shifts = Unit.shifts
    @units = Unit.names
    unit_name = params[:nurse][:unit]
    params[:nurse][:unit] = Unit.find_by_name(params[:nurse][:unit])
    if params[:nurse][:unit]
      params[:nurse][:position] = params[:nurse][:unit].nurses.find(:first, :order => "id desc").position + 1
    end
    @nurse = Nurse.new(params[:nurse])
    if not @nurse.save
      flash[:error] = @nurse.errors.full_messages
      params[:nurse][:unit] = unit_name
      render :action => 'new'
    else
      flash[:notice] = "#{@nurse.name} was successfully added."
      redirect_to nurse_manager_index_path(:admin => {:shift => params[:nurse][:shift], :unit => unit_name}) and return
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
    @nurse.attributes = params[:nurse]
    if not @nurse.save
      flash[:error] = @nurse.errors.full_messages
      params[:nurse][:unit] = unit_name
      render 'edit'
    else
      flash[:notice] = "#{params[:nurse][:name]} successfully updated."
      redirect_to nurse_manager_index_path(:admin => {:shift => params[:nurse][:shift], :unit => unit_name}) and return
    end
  end

  def destroy
    @nurse = Nurse.find(params[:id])
    unit_name = Unit.find_by_id(@nurse.unit_id).name
    shift_name = @nurse.shift
    @nurse.destroy
    flash[:notice] = "#{@nurse.name} was removed from the system."
    redirect_to nurse_manager_index_path(:admin => {:shift => shift_name, :unit => unit_name}) and return
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
  end

  def upload
    @units = Unit.names
    @shifts = Unit.shifts
    getNextParams
    if flash[:error] == nil
      flash[:error] = []
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
      redirect_to :action => :index, :admin => {:shift => @shift, :unit => @unit} and return
    end
  end

  def seniority
    @nurse = Nurse.find_by_id(params[:nurse_id])
    @nurses = Nurse.find_all_by_unit_id_and_shift(@nurse.unit_id, @nurse.shift, :order=>"years_worked DESC")
    @columns = ['name', 'seniority']
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

  def check_nurse_id
    return if admin_signed_in?
    permission_denied if current_nurse != Nurse.find(params[:nurse_id])
  end

end

class String
  def is_i?
    !!(self =~ /^[-+]?[0-9]+$/)
  end
end
