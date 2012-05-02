require 'date'

FactoryGirl.define do
  factory :admin do
    sequence :name do |n|
      "ADMINOMATIC#{n}20k"
    end
    sequence :email do |n|
      "admin#{n}@admin.com"
    end
    password 'admin_pw'

  end

  factory :nurse do
    sequence :name do |n|
      "NURSATRONIC SERIAL NO:#{n}"
    end
    sequence :position do |n|
      n
    end
    sequence :email do |n|
      "nurse#{n}@nurse.com"
    end
    num_weeks_off 10
    shift "PMs"
    unit
    password 'nurse_pw'
  end

  factory :unit do
    sequence :name do |n|
      "Bender Unit #{n}"
    end

  end

  factory :event do
    sequence :name do |n|
      "NURSATRONIC SERIAL NO:#{n}"
    end
    start_at DateTime.new(2012,3,4,0,0,0)
    end_at DateTime.new(2012,3,10,0,0,0)
    created_at DateTime.new(2012,1,1,0,0,0)
    all_day true
    pto false
    nurse
  end

  factory :nurse_baton do
    nurse
    shift 'PMs'
    unit
  end


end
