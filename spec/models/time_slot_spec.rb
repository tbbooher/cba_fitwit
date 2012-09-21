require 'spec_helper'

describe TimeSlot do

  before(:all) do
    cleanup_database
    @six_am = FactoryGirl.create(:six_am_slot)
    lid = @six_am.fitness_camp.location.id
    # create 10 registrations
    FactoryGirl.create_list(:user,10, location_id: lid).each do |the_user|
      #o = FactoryGirl.create(:order, user: the_user)
      FactoryGirl.create(:registration, time_slot_id: @six_am.id, user_id: the_user.id,
                         fitness_camp_id: @six_am.fitness_camp.id)
    end
  end

  it "should be able to add a set of meetings" do
    meetings = %w(2011-12-14 2011-12-23 2011-12-28).map{|m| Date.parse(m)}
    @six_am.add_meetings(meetings)
    @six_am.meetings.size.should eq(3)
  end

  it "should be able to add a set of meetings for every time slot in a camp" do
    meetings = %w(2011-12-14 2011-12-23 2011-12-28).map{|m| Date.parse(m)}
    five_am = FactoryGirl.create(:time_slot, fitness_camp: @six_am.fitness_camp)
    @six_am.add_meetings_for_every_ts(meetings)
    five_am.meetings.first.meeting_date.should == meetings.first
  end

  it "should have a start and end time" do
    @six_am.start_time_f.should eq("6:00AM")
    @six_am.end_time_f.should eq("7:00AM")
  end

  it "should show all the fit_wit_workouts a user has done in a time slot" do
    wo = FactoryGirl.create(:workout)
    ts = wo.meeting.time_slot
    ts.user_fit_wit_workouts(wo.user.id).first.score.should eq(wo.score)
    ts.user_fit_wit_workouts(wo.user.id).first.fit_wit_workout.name.should eq("Bob . . . The Conquest")
  end

  it "should not add a meeting if one already exists " do
    @six_am.meetings.clear
    @six_am.add_meetings([Date.parse("2011-12-1")])
    @six_am.add_meetings([Date.parse("2011-12-1")])
    @six_am.meetings.map{|m| m}.size.should == 1
    #@six_am.meetings.map{|m| m.meeting_date}.include?(Date.civil(2011,12,1)).should be false
  end

  it "should be able to display all registered campers" do
    # need to create 10 users and register them all
    @six_am.campers.size.should eq(10)
  end

  it "should show the meetings time" do
    @six_am.show_meeting_txt.should eq("<span class=\"time\">6:00AM</span>\n<span class=\"time\"> to 7:00AM</span>")
  end

  it "should have a short title, longer title" do
    @six_am.short_title.should eq("Parkour at 6:00AM")
    @six_am.longer_title.should eq("Parkour at 6:00AM located at #{@six_am.fitness_camp.location.name}")
  end

  it "should display all of its meetings dates" do
    # load some meetings dates
    fc = @six_am.fitness_camp
    @six_am.meetings.clear
    # add a meetings for every potential date
    meeting_count = 0
    (fc.session_start_date..fc.session_end_date).to_a.each do |dt|
      @six_am.meetings << Meeting.new(meeting_date: dt) if meeting_count < 10
      meeting_count += 1
    end
    @six_am.meeting_dates.size.should eq(10)
  end

  it "should show who is going" do
    @six_am.users_going.count.should eq(10) 
  end

  it "should be able to register a user and that user should have a saved reservation" do
    # still need to run this
    @user = FactoryGirl.create(:user)
    @registration = @six_am.create_user_registration(@user.id)
    @user.registrations.size.should eq(1)
  end

  it "should reject a user who attempts to register twice" do
    @user = FactoryGirl.create(:user)
    @registration1 = @six_am.create_user_registration(@user.id)
    @registration2 = @six_am.create_user_registration(@user.id)
    # second registration should result in an error

  end

end
