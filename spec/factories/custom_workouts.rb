# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :custom_workout do
    custom_name "Tim's mad situps'"
    workout_date 1.month.ago
    pr false
    description "Tim does 100 situps"
    score "5:23"
    is_a_fit_wit_workout false
  end
end