require 'spec_helper'

describe Registration do

  before(:each) do
    cleanup_database
    @ts = FactoryGirl.create(:time_slot)
    @location_A = @ts.fitness_camp.location
    @location_B = FactoryGirl.create(:location, name: "location B")
    @user_at_B = FactoryGirl.create(:user, location_id: @location_B.id)
    @user_at_A = FactoryGirl.create(:user, location_id: @location_A.id)
    @second_user_at_A = FactoryGirl.create(:user, location_id: @location_A.id)
  end

  it "should reject a user that is not in the same location as the time_slot" do
    r = Registration.new(user: @user_at_B, time_slot: @ts)
    r.should_not be_valid
    r.errors.messages[:user_id].first.should == "A user and time slot must share the same location"
  end

  it "should be valid if the user belongs to location and is unique" do
    r = Registration.new(user: @user_at_A, time_slot: @ts)
    r.should be_valid    
  end

  it "should reject a user that tries to register twice" do
    r = Registration.new(user: @user_at_A, time_slot: @ts)
    r.save.should be true
    second_r = Registration.new(user: @user_at_A, time_slot: @ts)
    second_r.should_not be_valid
    second_r.errors.messages[:user_id].first.should == "is already taken"
  end

  it "should reject a user that has registerd for two time slots in the same camp" do
    @ts_2_at_A = FactoryGirl.create(:time_slot, fitness_camp_id: @ts.fitness_camp.id)
    Registration.create(user: @user_at_A, time_slot: @ts_2_at_A)
    r = Registration.new(user: @user_at_A, time_slot: @ts)
    r.should_not be_valid
    r.errors.messages[:user_id].first.should == "is already taken"
  end

  it "should not reject a user if two people sign up for a camp" do
    r1 = Registration.create(user: @user_at_A, time_slot_id: @ts.id)
    r2 = Registration.new(user: @second_user_at_A, time_slot_id: @ts.id)
    r2.should be_valid
  end
  
end
