require 'spec_helper'

describe FitnessCamp do

  before(:all) do
    cleanup_database
    future = random_time_in_the_future
    past = random_time_in_the_past
    @fixed_camp = FactoryGirl.create(:fitness_camp)
    @Future_camp = FactoryGirl.create(:fitness_camp,
                                     session_start_date: future, 
                                     session_end_date: future + 4.weeks,
                                     title: "Grant Park 1"
                                     )
    @past_camp = FactoryGirl.create(:fitness_camp,
                                   session_start_date: past, 
                                   session_end_date: past + 4.weeks,
                                   title: "Grant Park 2"
                                   )
  end

  it "should display all" do
    assert_equal 3, FitnessCamp.all.size
  end

  it "should display all future fitness camps" do
    FitnessCamp.future.to_a.size.should be >= 1
  end

  it "should have a full title" do
    @fixed_camp.full_title.should == "Parkour from 12 Dec 12 to 01 Jan 13"
  end

  it "should have potential dates" do
    @fixed_camp.potential_dates.first.first.should == "Wed, 12-Dec"
  end

  it "should have a set of upcoming camps" do
    FitnessCamp.upcoming_and_current.last.title.should == "Grant Park 1"
  end

end
