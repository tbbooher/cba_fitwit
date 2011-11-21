FactoryGirl.define do
  factory :invitation do
   sponsor      User.first
   name         "Frank Zappa"
   email        "some@where.at"
   role         'confirmed_user'
   token        'abcdefgh'
  end
end
