FactoryGirl.define do
  factory :registration do
    #fc = FactoryGirl.create(:fitness_camp)
    time_slot
    fitness_camp_id {fc.id}
    order
    user
    price_paid 299.00
  end

end
