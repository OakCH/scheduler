factory :admin, :class => Admin do
  name "Jane Roe"
end

factory :event, :class => Event do
  name "A Fun Event!"
  start_at Date.today
  end_at Date.tomorrow
  created_at Date.today
  all_day true
end

factory :nurse, :class => Nurse do
  name "Lonnie Berg"
  shift "PMs"
  unit_id 42
  seniority 100
  num_weeks_off 10
  email "hello@hi.com"
end

factory :units, :class => Unit do
  name "Surgery"
end

factory :vacation_day, :class => VacationDay do
  date Date.today
  remaining_spots 1
  shift "PMs"
  unit_id 42
end
