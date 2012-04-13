class Event < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :nurse
  has_event_calendar
  
  validates_presence_of :name, :start_at, :end_at
  validates :all_day, :inclusion => {:in => [true, false]}

  validates_with Rules
  
  def self.additional_months
    return @@additional_months
  end
  
  def self.all_display_columns
    ['start date', 'end date', 'Change vacation', '']
  end

# the way the event_calendar gem handles colors for events
# on the calendar is with 'color' in the model. this sets the
# default color to gray
  def color
    "#7c7c7c" # gray
  end

end
