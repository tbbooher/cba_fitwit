require 'spec_helper'

describe TimeSlot do

  before(:all) do
    cleanup_database
    @user = FactoryGirl.create(:user)
    @six_am = FactoryGirl.create(:six_am_slot)
  end

  it "should have a start and end time" do
    @six_am.start_time_f.should eq("6:00AM")
    @six_am.end_time_f.should eq("7:00AM")
  end

  it "should show all the exercises a user has done in a time slot" do    
    wo = FactoryGirl.create(:workout)
    ts = wo.meeting.time_slot
    ts.user_exercises(wo.user.id).first.score.should eq("16")
    ts.user_exercises(wo.user.id).first.fit_wit_workout.name.should eq("Bob . . . The Conquest")
  end

  it "should be able to display all registered campers" do
    # need to create 10 users and register them all
    load_campers(@six_am)
    @six_am.campers.size.should eq(10)
  end

  it "should show the meeting time" do 
    @six_am.show_meeting_txt.should eq("<span class=\"time\">6:00AM</span>\n<span class=\"time\"> to 7:00AM</span>")
  end

  it "should have a short title, longer title" do
    @six_am.short_title.should eq("Parkour at 6:00AM")
    @six_am.longer_title.should eq("Parkour at 6:00AM located at #{@six_am.fitness_camp.location.name}")
  end

  it "should display all of its meeting dates" do
    # load some meeting dates
    fc = @six_am.fitness_camp
    # add a meeting for every potential date
    meeting_count = 0
    (fc.session_start_date..fc.session_end_date).to_a.each do |dt|
      @six_am.meetings << Meeting.new(meeting_date: dt) if meeting_count < 10
      meeting_count += 1
    end
    @six_am.meeting_dates.size.should eq(10)
  end

  it "should show who is going" do
    load_campers(@six_am)    
    @six_am.users_going.size.should eq(10)
  end
  
end
