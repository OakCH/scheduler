require 'date'

FactoryGirl.define do
  factory :admin do
    sequence :name do |n|
      "ADMINOMATIC#{n}20k"
    end
  end

  factory :nurse do
    sequence :name do |n|
      "NURSATRONIC SERIAL NO:#{n}"
    end
    sequence :seniority do |n|
      n
    end
    sequence :email do |n|
      "EMAILOTRONIC#{n}@SEMPERUBISUBUBI.com"
    end
    num_weeks_off 10
    shift "PMs"
    unit
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
    end_at DateTime.new(2012,3,6,0,0,0)
    created_at DateTime.new(2012,1,1,0,0,0)
    sequence :nurse_id do |n|
      n
    end
  end
end
