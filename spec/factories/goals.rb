# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :goal do
      goal_name "Lose 10 lbs"
      description "I want to lose my big gut"
      date_added Date.civil(2011,11,20)
      target_date Date.civil(2012,11,20)
      completed false
    end
end