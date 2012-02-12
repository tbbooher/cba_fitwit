require 'spec_helper'

describe Order do

  before(:all) do
    cleanup_database
    @admin = FactoryGirl.create(:admin)
  end

  it "should register timeslots from the cart" do
    pending "time slots"
  end

  it "should be able to complete a camp purchase" do
    pending "until i get the mocks working"
  end


end
