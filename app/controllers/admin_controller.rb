class AdminController < ApplicationController
  
  # attr_reader :unit, :shift
  
  def copyFile(file)
    File.open(Rails.root.join('public', 'uploads', file.original_filename), 'wb') do |f|
      f.write(file.read)
    end
  end
  
  def deleteFile(file)
    File.delete(Rails.root.join('public', 'uploads', file.original_filename))
  end

  def upload
    @units = Unit.names
    @shifts = Unit.shifts
    flash[:notice] = []
    
    if params[:commit] == 'Next' || params[:commit] == 'Upload'
      @readyToUpload = true
      if (params[:admin][:unit])
        @unit = Unit.find_by_name(params[:admin][:unit])
      end
      @shift = params[:admin][:shift]
      
      if @unit == nil
        flash[:notice] << "Error: Forgot to specify unit"
        @readyToUpload = false
      end
      if @shift == nil
        flash[:notice] << "Error: Forgot to specify shift"
        @readyToUpload = false
      end
    end

    if params[:commit] == 'Upload'
      @file = params[:admin][:upload]
      if @file
        copyFile(@file)
        Nurse.replace_from_spreadsheet(Rails.root.join('public', 'uploads', @file.original_filename).to_path, @unit, @shift)
        @nurses = Nurse.find(:all)
        @parsed_results = Nurse.parsing_errors
        if (@parsed_results[:messages])
          @parsed_results[:messages].each do |msg|
            flash[:notice] << msg
          end
        end
        deleteFile(@file)
      else 
        flash[:notice] << "Error: Please select a file"
      end
      
    end

  end

end