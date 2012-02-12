FactoryGirl.define do
  sequence :email do |n|
    "fitwit_user#{n}@jokerthing.com"
  end

  sequence :name do |n|
    "AnotherUser#{n}"
  end

  factory :user do
    email
    name
    location
    roles_mask 1
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    gender {rand > 0.5 ? :male : :female}
    occupation "Scientist"
    company "USAF"
    street_address1 "1050 Wilderness"
    street_address2 ""
    city "Tipp City"
    us_state "OH"
    zip "45420"
    primary_phone "973-238-3333"
    secondary_phone "382-282-2828"
    t_shirt_size "large"
    emergency_contact_name {Faker::Name.first_name + " " + Faker::Name.last_name}
    emergency_contact_relationship {rand > 0.4 ? "spouse" : "dad"}
    weight 176.22
    how_did_you_hear_about_us "church"
    fitness_level 1
    date_of_birth "2008-12-22"
    height_inches 8
    height_feet 7
    veteran_status :newbie
    number_of_logins 4
    member false
    password "secret"
    password_confirmation "secret"
    goals {[FactoryGirl.build(:goal)]}
  end

  factory :admin, :class => User do
    email 'admin@yourdomain.com'
    name 'Administrator'
    roles_mask 5
    password "secret"
    password_confirmation "secret"
    first_name "Bob"
    last_name "The Builder"
    street_address1 "1020 Willoby Lane"
    company "Mead"
    city "Dayton"
    us_state "OH"
    zip "45420"
    primary_phone "937-544-2828"
  end

end
