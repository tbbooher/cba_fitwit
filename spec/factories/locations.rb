# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
      name {Faker::Name.name}
      description "Down by the river"
      contact_info "270282-8228"
      city "Atlanta"
      created_at "2011-11-13 15:11:51"
      updated_at "2011-11-13 15:11:51"
      us_state "GA"
      zip "22304"
      street_address "211 Birch Road"
      lat 9.99
      lon 9.99
      #fitness_camps {|fc| [fc.association(:fitness_camp)]}
  end

  factory :location_a, class: Location do
      name "Location A"
      description "Just a test location"
      contact_info "location@a.com"
      city "Detroit"
      created_at "2011-11-13 15:11:51"
      updated_at "2011-11-13 15:11:51"
      us_state "MI"
      zip "43238"
      street_address "248 Location A Ave"
      lat 0.00
      lon 0.00
  end
end
