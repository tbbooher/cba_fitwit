require 'spec_helper'

describe Meeting do

  before(:all) do
    cleanup_database
    @meeting = FactoryGirl.create(:meeting)
  end

  it "should have a meeting date" do
    @meeting.meeting_date_f.should eq("15-Nov")
  end

end
