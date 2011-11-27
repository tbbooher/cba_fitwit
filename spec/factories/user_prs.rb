# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_pr do
      score "MyString"
      rxd false
      common_value 1.5
    end
end