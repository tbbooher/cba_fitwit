FactoryGirl.define do
  factory :time_slot do
    sold_out false
    fitness_camp
    start_time {Time.local(2000,1,1,6)}
    end_time {Time.local(2000,1,1,6) + 1.hour}

    trait :six_am do
      six_am = Time.local(2000,1,1, 6)
      start_time {six_am}
      end_time {six_am + 1.hour}
    end

    trait :ten_pm do
      ten_pm = Time.local(2000,1,1, 22)
      start_time {ten_pm}
      end_time {ten_pm + 1.hour}
    end

    trait :sold_out do
      sold_out true
    end

    factory :six_am_slot, traits: [:six_am]
    factory :ten_pm_slot, traits: [:ten_pm]
    factory :six_am_sold_out, traits: [:six_am, :sold_out]

  end
end
