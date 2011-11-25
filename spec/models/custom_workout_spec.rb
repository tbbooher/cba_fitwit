require 'spec_helper'

describe CustomWorkout do

  before(:all) do
    cleanup_database
    @cw = Factory.create(:custom_workout)
  end

  it "can be a fww that a user does themself" do
    fww = Factory.create(:fit_wit_workout)
    fww_cw = Factory.create(:custom_workout, custom: false, fit_wit_workout: fww)
    fww_cw.title.should eq(fww.name)
  end

  it "should be able to pull out the proper title" do
    @cw.title.should eq("Tim's mad situps'")
  end
end