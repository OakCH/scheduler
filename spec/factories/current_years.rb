# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :current_year do
    sequence :year do |n|
      2010+n
    end
  end
end
