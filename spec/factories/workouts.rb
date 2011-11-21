# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :workout do
      score "16"
      user_note "This was a tough one!"
      rxd false
      common_value 13
      user
      meeting
      fit_wit_workout
    end
end
