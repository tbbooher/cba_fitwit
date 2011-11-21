FactoryGirl.define do

  sequence :title do |n|
    "Fitness Camp Number #{n}"
  end

  factory :fitness_camp do
    title "Parkour"
    session_start_date  Date.parse("12 Dec 2012")
    session_end_date  Date.parse("1 Jan 2013")
    session_active  true
    description Faker::Company.bs
    location # :factory => :location
  end

  factory :a_camp, class: :fitness_camp do
    title
    session_start_date Date.parse("1 Jan 2012")
    session_end_date  Date.parse("1 Jan 2013")
    session_active  true
    description Faker::Company.bs
    location
  end
end
