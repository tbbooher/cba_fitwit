require 'spec_helper'

describe "workout" do

  before(:all) do
    cleanup_database
    create_default_userset
    @w = FactoryGirl.create(:workout)
  end

  it "should be able to find all workouts for a fitness camp" do
    #users = FactoryGirl.build_list(:user, 10).each do |the_user|
    #  FactoryGirl.build_list(:workout, 3, user: the_user)
    #end
    Workout.for_camp(@w.meeting.time_slot.fitness_camp).first.should eq(@w)
  end

  it "should be able to find all workouts for a user" do
    Workout.for_user(@w.user).first.should eq(@w)
  end

  it "should have a combination of scopes to find workouts for a user at a fitness camp" do
    camp = @w.meeting.time_slot.fitness_camp
    user = @w.user
    Workout.for_user(user).for_camp(camp).first.should eq(@w)
    # TODO -- we might want to through in some confusers to test this
  end

  it "should store a PR if a workout is added with a better common value" do
    fww = @w.fit_wit_workout
    user = @w.user
    user.find_pr_for(fww).score.should eq(@w.score)
    # a better score should update
    FactoryGirl.create(:workout, score: "1:00",
                                     user: user,
                                     fit_wit_workout: fww)
    user.find_pr_for(fww).score.should eq("1:00")
    # an inferior score should not update
    FactoryGirl.create(:workout, score: "10:00",
                                     user: user,
                                     fit_wit_workout: fww)
    user.find_pr_for(fww).score.should eq("1:00")
  end
end
