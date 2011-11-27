# -*- coding: utf-8 -*-
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fit_wit_workout do
      name "Bob . . . The Conquest"
      description "100 yard field run forwards and then  100 yard backwards run with push-ups every 45 sec. Campers will hear a whistle alerting them to drop down and start push-ups for 15 seconds. – 8 rounds (newbies do 6 rounds) (Every push-up counts as one second you can take off your total time at the end).\nAfter 8 rounds (down and back = 1 round), finish with 25 burpees, 50 sit-ups, 100 squats (newbies do 15 burpees, 30 sit-ups, 60 squats)"
      units "time"
      score_method "simple-time"
  end
  # AMRAP: 6 pullups, 6 dips, 10 situps
  # score-method:  simple-rounds
  # Description: 
end
