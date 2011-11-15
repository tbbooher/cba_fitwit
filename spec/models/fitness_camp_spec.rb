require 'spec_helper'

describe FitnessCamp do

  before(:all) do
    cleanup_database
    # pass in these parameters manually
    @future_fitness_camp = FactoryGirl.create(:fitness_camp)
    @past_fitness_camp = FactoryGirl.create(:fitness_camp)
    @current_fitness_camp = FactoryGirl.create(:fitness_camp)
    @user = FactoryGirl.create(:user)
    @users = FactoryGirl.create_list(:user, 10)
    ts = FactoryGirl.create(:time_slot)
    # assign 10 users to each camp and 3 associated time_slots
    # this user should have
  end

  it "should have a full title" do
    assert_equal "Parkour from 12 Dec 12 to 01 Jan 13", @future_fitness_camp.full_title
  end

  it "should have potential dates" do
    # TODO -- we need to flush this out
    assert_not_nil @f.potential_dates
  end

  it "should have lots of time slots" do
    pending "until we build the factories for time slots"
  end

  it "should have a set of upcoming camps" do
    pending "self.find_upcoming(@u.id)"
  end

  it "should be able to find upcoming and current camps for all users" do
    assert_not_nil FitnessCamp.find_upcoming_and_current
  end

  it "should be able to find past camps a user has done" do
    assert_not_nil FitnessCamp.find_past
  end

  it "should be able to find everyone registered for a fitness camp" do
    # @f.find_registered
    pending
  end

  it "should be able to display all exercises for a user in a camp" do
    pending
  end

end
