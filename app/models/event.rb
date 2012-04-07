class Event < ActiveRecord::Base
  belongs_to :nurse
  has_event_calendar

  attr_accessible :name, :start_at, :end_at
  attr_accessible :all_day, :created_at

  validates_presence_of :name, :start_at, :end_at
  validates :all_day, :inclusion => {:in => [true, false]}

  def self.all_display_columns
    ['start date', 'end date', 'Change vacation', '']
  end
end
