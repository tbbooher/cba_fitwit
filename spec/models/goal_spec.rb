require 'spec_helper'

describe Goal do
  before(:all) do
    cleanup_database
    create_default_userset
    @user = User.first
  end

  it "should be able to create and save a goal" do
    goal = Goal.new
    @user.goals << goal
    @user.save
    @user.goals.size.should == 1
  end

end