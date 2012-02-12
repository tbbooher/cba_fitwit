FactoryGirl.define do
  factory :registration do
    fc = FactoryGirl.create(:fitness_camp)
    association :time_slot, factory: :time_slot, fitness_camp_id: fc.id
    fitness_camp_id {fc.id}
    order
    association :user, factory: :user, location_id: fc.location.id
    price_paid 299.00
  end
end
