# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :measurement do
      review_date "2011-11-24"
      height 1.5
      weight 1.5
      chest 1.5
      waist 1.5
      hip 1.5
      right_arm 1.5
      right_thigh 1.5
      bmi 1.5
      bodyfat_percentage 1
    end
end