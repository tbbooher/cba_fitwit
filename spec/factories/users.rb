


FactoryGirl.define do
  sequence :email do |n|
    "fitwit_user#{n}@joker.com"
  end

  sequence :name do |n|
    "AnotherUser#{n}"
  end

  factory :user do
    email
    name
    roles_mask 1
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    gender {rand > 0.5 ? 1 : 2}
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
    emergency_contact_information "mom 3222"
    weight 176.22
    how_did_you_hear_about_us "church"
    history_of_heart_problems false
    cigarette_cigar_or_pipe_smoking false
    increased_blood_pressure false
    increased_total_blood_cholesterol false
    diabetes_mellitus true
    heart_problems_chest_pain_or_stroke false
    breathing_or_lung_problems false
    muscle_joint_or_back_disorder false
    hernia false
    chronic_illness false
    obesity true
    recent_surgery false
    pregnancy false
    difficulty_with_physical_exercise false
    advice_from_physician_not_to_exercise false
    fitness_level 1
    date_of_birth "2008-12-22"
    height_inches 8
    height_feet 7
    veteran_status 1
    number_of_logins 4
    has_active_subscription false
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
