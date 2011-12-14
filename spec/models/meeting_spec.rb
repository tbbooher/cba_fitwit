require 'spec_helper'

describe Meeting do

  before(:all) do
    cleanup_database
    @meeting = FactoryGirl.create(:meeting)
  end

  it "should have a meetings date" do
    @meeting.meeting_date_f.should eq("15-Nov") 
  end

  it "should be able to display all attending ids" do
    @meeting.attendees.size.should eq(0)
    FactoryGirl.create_list(:user,10).each do |the_user|
      @meeting.attendees << the_user 
    end
    @meeting.attendees.size.should eq(10) 
  end

  it "should show if a given user has attended" do
    @user = FactoryGirl.create(:user)
    @meeting.attended?(@user).should be false
    @meeting.attendees << @user
    @meeting.attended?(@user).should be true
  end

end
