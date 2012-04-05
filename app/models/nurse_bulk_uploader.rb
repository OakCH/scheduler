module NurseBulkUploader
  
  attr_reader :parsing_errors

  # to add another column, add the symbol representing the database field
  # to PossibleColumns and optionally to RequiredColumns and define
  # a match_col_name function below
  PossibleColumns = [:name, :num_weeks_off, :email, :years_worked]
  RequiredColumns = [:name, :num_weeks_off, :email]
  
  def replace_from_spreadsheet(file_path, unit, shift)
    uploader = Uploader.new(unit, shift)
    uploader.replace_from_spreadsheet(file_path)
    @parsing_errors = uploader.parsing_errors
  end
  
   # helper methods for the views
  def optional_columns
    nice_col_names(PossibleColumns - RequiredColumns)
  end
  
  def required_columns
    nice_col_names(RequiredColumns)
  end
  
  def all_columns
    nice_col_names(PossibleColumns)
  end
  
  def all_columns_as_sym
    PossibleColumns
  end
  
  def nice_col_name(sym)
    sym.to_s.split('_').map{ |word| word.capitalize }.join(' ')
  end
  
  def nice_col_names(col_collection)
    col_collection.map { |sym| nice_col_name(sym) }
  end
  
  class Uploader
    
    attr_accessor :unit, :shift, :parsing_errors, :sheet, :cols
    
    def initialize(unit, shift)
      self.unit = unit
      self.shift = shift
      self.initialize_error_messages
    end
    
    def replace_from_spreadsheet(file_path)
      return if !load_from_file(file_path)
      return if !set_column_positions
      destroy_original_nurses
      create_nurses
    end
    
    def load_from_file(file_path)
      case File.extname(file_path)
      when '.xls' then type = Excel
      when '.xlsx' then type = Excelx
      end
      if type
        @sheet = type.new(file_path)
        true # indicator if method call was success
      else
        error_invalid_type
        false
      end
    end
    
    def set_column_positions
      self.cols = {}
      iterate_columns(sheet.first_column, sheet.last_column)
      if !necessary_cols_associated
        error_missing_headers
        false
      else
        true
      end
    end
    
    def destroy_original_nurses     
      self.parsing_errors[:database_changed] = true
      @unit.nurses.where(:shift => self.shift).destroy_all
    end
    
    def create_nurses
      start_row = sheet.first_row + 1 # skip header row
      seniority_counter = 1
      start_row.upto(sheet.last_row) do |row|
        create_nurse(row, seniority_counter)
        seniority_counter += 1
      end
    end
    
    def initialize_error_messages
      self.parsing_errors = {}
      self.parsing_errors[:database_changed] = false
      self.parsing_errors[:messages] = []
    end
    
    # helper methods for create_nurses
    def create_nurse(row, count)
      nurse_params = { :seniority => count, :unit => self.unit, :shift => self.shift }
      PossibleColumns.each do |col_name|
        nurse_params[col_name] = sheet.cell(row, cols[col_name]) if cols[col_name]
      end
      nurse = Nurse.new(nurse_params)
      nurse.save
      set_creation_errors(row, nurse.errors)
    end
    
    def set_creation_errors(row, errors)
      nurse_errors = errors.full_messages.map {|message| "Nurse in row #{row}: " + message}
      self.parsing_errors[:messages] = (self.parsing_errors[:messages] << nurse_errors).flatten
    end
    
    # helper methods for set_column_positions
    def iterate_columns(start_col, end_col)
      return if !start_col or !end_col
      start_col.upto (end_col) do |col|
        associate_column(sheet.first_row, col)
        break if all_cols_associated # avoid going through extra columns
      end
    end 
    
    def associate_column(row, col)
      cell = @sheet.cell(row, col)
      cell = cell.downcase if cell
      
      PossibleColumns.each do |col_name|
        return cols[col_name] = col if send("match_#{col_name.to_s}", cell)
      end
    end
    
    def match_name(cell)
      cell =~ /^(?:code)?name$/
    end
    
    def match_num_weeks_off(cell)
      cell =~ /^num(?:ber)? (?:of )?weeks off$/
    end
    
    def match_years_worked(cell)
      cell =~ /^years(?: worked)?$/
    end
    
    def match_email(cell)
      cell =~ /^e\-?mail$/
    end
    
    def necessary_cols_associated
      check_hash_assoc RequiredColumns
    end
    
    def all_cols_associated
      check_hash_assoc PossibleColumns
    end
    
    def check_hash_assoc(params_to_check)
      params_to_check.each do |term|
        return false if !self.cols[term]
      end
      return true
    end
    
    # error handling methods
    def error_invalid_type
      self.parsing_errors[:messages] << 'File to parse was not a valid xls or xlsx'
    end
    
    def error_missing_headers
      RequiredColumns.each do |term|
        self.parsing_errors[:messages] << missing_header_message(term) if !cols[term]
      end
    end
    
    def missing_header_message(sym)
      "Header row is missing the #{Nurse.nice_col_name(sym)} column"
    end
  end
  
end
