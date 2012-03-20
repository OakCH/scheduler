factory :admin, :class => Admin do
sequence :name do |n|
    "ADMINOMATIC#{n}"
  end
end

factory :event, :class => Event do
  sequence :name do |n|
    name "FUNEVENTOMATIC#{n}"
  end
  start_at Date.today
  end_at Date.tomorrow
  created_at Date.today
  all_day true
end

factory :nurse, :class => Nurse do
  sequence :name do |n|
    "NURSATRONIC#{n}"
  end
  shift "PMs"
  unit_id 42
  sequence :seniority do |n|
    n
  end
  num_weeks_off 10
  email "hello@hi.com"
  vacation_days
  unit
end

factory :units, :class => Unit do
  nurse
  vacation_days
  name "Surgery"
end

factory :vacation_day, :class => VacationDay do
  date Date.today
  remaining_spots 1
  shift "PMs"
  unit_id 42
  unit
  nurses
end
