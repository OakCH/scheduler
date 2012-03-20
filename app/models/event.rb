class Event < ActiveRecord::Base
  has_event_calendar
  validates :name, :start_at, :end_at, :presence => true
  validates :created_at, :presence => true
  validates :all_day, :inclusion => {:in => [true, false]}
  validates :check_date_order

  def check_date_order
    start_at < end_at
  end

end
