namespace :data do
  desc "Get some camp and workout data in the database"
  task :generate_workout_data => :environment do
    [User, Workout, FitWitWorkout].each {|i| i.delete_all}
    u = FactoryGirl.create(:user, name: 'Tim',
                           email: 'tim@theboohers.org',
                           password: 'fitwit',
                           password_confirmation: 'fitwit')
    # delete all other users
    cindy = FactoryGirl.create(:fit_wit_workout, score_method: "simple-rounds", name: "cindy")
    fiveK = FactoryGirl.create(:fit_wit_workout, score_method: "simple-time", name: "5k")
    # load the default user
       FactoryGirl.create(:workout, fit_wit_workout: cindy,
                          score: "5", user: u)
    ["15:21", "16:23","15:48","16:20", "17:10", "18:30"].each_with_index do |race_time, i|
      m = FactoryGirl.create(:meetings, meeting_date: Date.civil(2012,12,i+5))
      FactoryGirl.create(:workout, fit_wit_workout: fiveK,
                         score: race_time, user: u, meetings: m)
    end

       FactoryGirl.create(:workout, fit_wit_workout: fiveK,
                          score: "16:21", user: u)
       FactoryGirl.create(:workout, fit_wit_workout: fiveK,
                          score: "17:21", user: u)
       FactoryGirl.create(:workout, fit_wit_workout: fiveK,
                          score: "18:21", user: u)
       FactoryGirl.create(:workout, fit_wit_workout: fiveK,
                          score: "19:21", user: u)
    rounds = [1,2,3,4,5,6,7,8,9,10]
    times = ["15:23",
             "20:23",
             "24:22",
             "18:46",
             "16:23",
             "27:21",
             "20:22",
             "28:33",
             "30:43",
             "21:63"]
    FactoryGirl.create_list(:user, 10).each_with_index do |usr, i|
       FactoryGirl.create(:workout, fit_wit_workout: cindy,
                          score: rounds[i], user: usr)
       FactoryGirl.create(:workout, fit_wit_workout: fiveK,
                          score: times[i], user: usr)
    end
  end
end

