class Event < ActiveRecord::Base
  belongs_to :nurse
  has_event_calendar
end
