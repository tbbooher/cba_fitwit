require 'spec_helper'

describe CustomWorkout do

  before(:all) do
    cleanup_database
    @cw = Factory.build(:custom_workout)
  end

  it "can be a fww that a user does themself" do
    fww = Factory.create(:fit_wit_workout)
    fww_cw = Factory.build(:custom_workout, is_a_fit_wit_workout: true, fit_wit_workout: fww)
    fww_cw.title.should eq(fww.name)
  end

  it "should be able to pull out the proper title" do
    @cw.title.should eq("Tim's mad situps'")
  end

  it "should be able to add a custom workout for a user " do
    u = FactoryGirl.build(:user)
    u.custom_workouts.push(@cw)
    u.custom_workouts.size.should eq(1)
    u.save!
    # now retrieve this from the database
    u2 = User.where(_id: u.id).first
    u2.custom_workouts.first.should eq(@cw)
  end
end