require 'spec_helper'

describe "user" do

  before(:all) do
    cleanup_database
    create_default_userset
  end

  it "should store geo-location" do
    user = User.first
    user.location_token = "48.2073, 14.2542"
    user.save!
    user.reload
    assert user.location[:lat] == 48.2073,
      "User's latitude should be 48.2073 but is #{user.location.inspect}"
    assert user.location[:lng] == 14.2542
      "User's longitude should be 14.2542 but is #{user.location.inspect}"
  end

  it "should have a number of time slots" do
    r = FactoryGirl.create(:registration) # this creates a registration
    st_time = Time.local(2000,1,1,6)
    r.time_slot.start_time.should eq(st_time)
    user = r.order.user
    user.user_time_slots.first.start_time.should eq(st_time) 
  end

  it "should be able to recall all past fitness camps" do
    u = FactoryGirl.create(:user)
    FactoryGirl.create_list(:a_camp, 10).each_with_index do |camp, i|
      t = Time.local(1,1,1,6)
      ts = TimeSlot.create(start_time: t, end_time: t + 1.hour, fitness_camp: camp)
      my_order = Order.create(amount: i, user: u, state: 'pending', description: "a test order {i}")
      Registration.create(user: u, time_slot: ts, order: my_order)
    end
    u.orders.size.should eq(10)
    u.past_fitness_camps.size.should eq(10)
  end

  it "should be able to produce a series of time slots" do
    u = FactoryGirl.create(:user)
    FactoryGirl.create_list(:a_camp, 10).each_with_index do |camp, i|
      t = Time.local(1,1,1,6)
      ts = TimeSlot.create(start_time: t, end_time: t + 1.hour, fitness_camp: camp)
      my_order = Order.create(amount: i, user: u, state: 'pending', description: "a test order {i}")
      Registration.create(user: u, time_slot: ts, order: my_order)
    end
    #u.orders.size.should eq(10)
    u.user_time_slots.first.start_time.should eq(Time.local(1,1,1,6))
  end

end
