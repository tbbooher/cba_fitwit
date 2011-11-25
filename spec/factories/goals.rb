# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :goal do
      goal_name "MyString"
      description "MyString"
      date_added "2011-11-24"
      target_date "2011-11-24"
      completed false
      completed_date "2011-11-24"
    end
end