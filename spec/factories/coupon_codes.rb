# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon_code do
      code "1XF22R"
      price "1000"
      active true
      uses 5
      max_uses 10
      description "10 dollars for up to 10 people"
      expires_at "2011-12-26"
    end
end