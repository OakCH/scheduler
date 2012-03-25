class Event < ActiveRecord::Base
  belongs_to :nurse
  has_event_calendar
  
  validates_presence_of :name, :start_at, :end_at
  validates_presence_of :created_at
  validates :all_day, :inclusion => {:in => [true, false]}
  #  validates :check_date_order
  
  def check_date_order
    start_at < end_at
  end

end
