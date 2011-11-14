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
    assert_not_nil @l.future_fitness_camps
  end

end
