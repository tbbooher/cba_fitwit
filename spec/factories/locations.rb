# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
      name Faker::Name.name
      description "Down by the river"
      directions "ON the left of spring street"
      contact_info "270282-8228"
      city "Atlanta"
      created_at "2011-11-13 15:11:51"
      updated_at "2011-11-13 15:11:51"
      us_state "GA"
      short_description "The best place for your family!"
      zip "22304"
      street_address "211 Birch Road"
      lat 9.99
      lon 9.99
      #fitness_camps {|fc| [fc.association(:fitness_camp)]}
    end
end
