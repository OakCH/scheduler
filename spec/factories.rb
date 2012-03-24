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

end
