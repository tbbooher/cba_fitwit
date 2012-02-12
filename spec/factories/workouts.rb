# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  sequence :score do |n|
    "#{n}:53"
  end

  factory :workout do
      score
      user_note "This was a tough one!"
      rxd {rand > 0.5 ? false : true}
      # common_value 13
      user
      meeting
      fit_wit_workout
    end
end
