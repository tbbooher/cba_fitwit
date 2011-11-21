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

end
