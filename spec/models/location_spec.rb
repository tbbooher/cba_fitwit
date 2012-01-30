require 'spec_helper'

describe Location do

  before(:all) do
    cleanup_database
    @l = FactoryGirl.create(:location)
  end

  it "should be able to have many sponsors" do
    sponsor1 = FactoryGirl.create(:sponsor, name: Faker::Company.name)
    sponsor2 = FactoryGirl.create(:sponsor, name: Faker::Company.name)

    @l.sponsors << sponsor1
    @l.sponsors << sponsor2
    assert @l.valid?
    assert_equal 2, @l.sponsors.count, "wrong number of sponsors"
  end

  it "should have a summary" do
    assert_not_nil @l.summary, "summary is nil"
  end

  it "should have a nice multi-line address" do
    assert_not_nil @l.multi_line_address
  end

  it "should have a future set of fitness camps" do
    f = FactoryGirl.create(:fitness_camp)
    @l.fitness_camps << f
    assert_equal "Parkour", @l.future_fitness_camps.first.title
  end

  it "should be able to report on all states with FitWit's" do
    Location.all.to_a.size.should eq(2)
    @l.us_state.should eq("GA")
    assert_equal [["GA", "Georgia"]], Location.find_all_states
    assert_equal 1, Location.find_all_states.size
  end

  it "should be able to show the future fitness camp count" do
    assert_equal 1, @l.future_fitness_camp_count
  end

  context "I should be able to get the most recent timeslot" do
    before :all do
      cleanup_database
      very_far_back = 20.months.ago
      far_back = 10.months.ago
      not_far_back = 5.months.ago
      future = 1.month.from_now
      @location1 = FactoryGirl.create(:location)
      @location2 = FactoryGirl.create(:location)
      @six_am = Time.local(2010,1,1,6,0)
      @six_thirty_am = Time.local(2010,1,1,6,30)
      @six_pm = Time.local(2010,1,1,18,10)
      @eight_am = Time.local(2010,1,1,8,0)
      @f_far_back = FactoryGirl.create(:fitness_camp, session_start_date: far_back, location_id: @location1.id, title: "old camp")
      @f_not_far_back = FactoryGirl.create(:fitness_camp, session_start_date: not_far_back, location_id: @location2.id, title: "new camp")
      @f_very_far_back = FactoryGirl.create(:fitness_camp, session_start_date: very_far_back, location_id: @location1.id, title: "very old camp")
      @ts1 = FactoryGirl.create(:time_slot, fitness_camp_id: @f_far_back.id, start_time: @six_am)
      @ts2 = FactoryGirl.create(:time_slot, fitness_camp_id: @f_far_back.id, start_time: @six_pm)
      @ts3 = FactoryGirl.create(:time_slot, fitness_camp_id: @f_far_back.id, start_time: @eight_am)
      @ts4 = FactoryGirl.create(:time_slot, fitness_camp_id: @f_not_far_back.id, start_time: @six_am)
      @ts5 = FactoryGirl.create(:time_slot, fitness_camp_id: @f_very_far_back.id, start_time: @six_am)
      @ts6 = FactoryGirl.create(:time_slot, fitness_camp_id: @f_far_back.id, start_time: @six_thirty_am)
      @new_camp = FactoryGirl.create(:fitness_camp, session_start_date: future, location_id: @location1.id, title: "new camp")
    end
    it "and not get one from another location" do
      @location1.find_previous_camp(@six_am, @new_camp).should_not be @ts4
    end
    it "and not get one in the same location with a more recent hour" do
      @location1.find_previous_camp(@six_am, @new_camp).should_not be @ts2
    end
    it "and only the most recent time slot" do
      @location1.find_previous_camp(@six_am, @new_camp).should == @ts1
    end
    it "and it should be empty if there are no previous time_slots at that time" do
      @location1.find_previous_camp(Time.local(2010,1,1,10,0), @new_camp).should be nil
    end
  end

end
