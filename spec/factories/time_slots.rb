FactoryGirl.define do
  factory :time_slot do
    #my_time = 4.weeks.from_now
    sold_out false
    fitness_camp
    start_time {Time.now}
    end_time {Time.now + 8.weeks}

    trait :future_slot do
      start_time { 4.weeks.from_now }
      end_time { 12.weeks.from_now }
    end

    trait :past_slot do
      start_time {4.months.ago}
      end_time {4.months.ago + 8.weeks}
    end

    trait :future_6am do
      st = 4.months.from_now
      six_am = Time.local(st.year,st.month,st.day, 6)
      start_time {six_am}
      end_time {six_am + 8.weeks}
    end

    trait :future_10pm do
      st = 4.months.from_now
      six_am = Time.local(st.year,st.month,st.day, 22)
      start_time {six_am}
      end_time {six_am + 8.weeks}
    end

    trait :sold_out do
      sold_out true
    end

    factory :a_future_time_slot, traits: [:future_slot]
    factory :a_future_time_slot_sold_out, traits: [:future_slot, :sold_out]
    factory :a_past_time_slot, traits: [:past_slot]
    factory :future_6am_slot, traits: [:future_6am]
    factory :future_10pm_slot, traits: [:future_10pm]

  end
end