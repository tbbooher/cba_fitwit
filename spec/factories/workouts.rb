# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :workout do
      score "MyString"
      user_note "MyString"
      rxd false
      common_value 1.5
    end
end