Factory.define :user do |u|
  u.email Faker::Internet.email
  u.name Faker::Name.last_name
  u.roles_mask 1
  u.first_name "Michael"
  u.last_name "Payne"
  u.gender 1
  u.occupation "Scientist"
  u.company "USAF"
  u.street_address1 "1050 Wilderness"
  u.street_address2 ""
  u.city "Tipp City"
  u.us_state "OH"
  u.zip "45420"
  u.primary_phone "973-238-3333"
  u.secondary_phone "382-282-2828"
  u.t_shirt_size "large"
  u.emergency_contact_information "mom 3222"
  u.weight 176.22
  u.how_did_you_hear_about_us "church"
  u.history_of_heart_problems false
  u.cigarette_cigar_or_pipe_smoking false
  u.increased_blood_pressure false
  u.increased_total_blood_cholesterol false
  u.diabetes_mellitus true
  u.heart_problems_chest_pain_or_stroke false
  u.breathing_or_lung_problems false
  u.muscle_joint_or_back_disorder false
  u.hernia false
  u.chronic_illness false
  u.obesity true
  u.recent_surgery false
  u.pregnancy false
  u.difficulty_with_physical_exercise false
  u.advice_from_physician_not_to_exercise false
  u.fitness_level 1
  u.date_of_birth "2008-12-22"
  u.height_inches 8
  u.height_feet 7
  u.veteran_status 1
  u.number_of_logins 4
  u.has_active_subscription false
  u.password "secret"
  u.password_confirmation "secret"
end

Factory.define :admin, :class => User do |u|
  u.email 'admin@yourdomain.com'
  u.name 'Administrator'
  u.roles_mask 5
  u.password "secret"
  u.password_confirmation "secret"
  u.first_name "Bob"
  u.last_name "The Builder"
  u.street_address1 "1020 Willoby Lane"
  u.company "Mead"
  u.city "Dayton"
  u.us_state "OH"
  u.zip "45420"
  u.primary_phone "937-544-2828"
end