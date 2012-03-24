class Event < ActiveRecord::Base
  belongs_to :nurse
  has_event_calendar

  def self.get_all_by_month(shift, unit_id)
  end

end
