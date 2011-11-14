# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sponsor do
      name Faker::Company.name
      description Faker::Company.bs
      address  "#{Faker::Address.street_address},#{Faker::Address.city}, #{Faker::Address.state}, #{Faker::Address.zip}"

      phone Faker::PhoneNumber.phone_number
      url "www.#{Faker::Internet.domain_name}"
      img_name "MyString"
      created_at "2011-11-13 15:10:07"
      updated_at "2011-11-13 15:10:07"
      logo_file_name "MyString"
      logo_content_type "MyString"
      logo_file_size 1
      logo_updated_at "2011-11-13 15:10:07"
      logo_style "silly style"
    end
end
