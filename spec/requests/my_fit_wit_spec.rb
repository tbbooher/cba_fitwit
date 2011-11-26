require File::expand_path('../../spec_helper', __FILE__)

describe "The my_fit_wit section" do

  before(:all) do
    cleanup_database
    create_default_userset
    #load_some_camp_history
  end

  before(:each) do
    log_in_as "admin@iboard.cc", 'thisisnotsecret'
  end

  it "should show the my_fit_wit page" do
    visit my_fit_wit_index_path
    page.should have_content("Welcome back") 
  end

  it "should load a fitness progress page" do
    visit my_fit_wit_fit_wit_workout_progress_path
    #current_user.should eq(User)
    page.should have_content("Calendar")
  end

  it "should load a camp fit_wit_workout_progress page" do
    visit my_fit_wit_camp_fit_wit_workout_progress_path
    page.should have_content("Camp report")
  end

  it "should load a goals page" do
    visit my_fit_wit_my_goals_path
    page.should have_content("Set your goals")
  end

  it "should let someone add a custom workout" do
    visit my_fit_wit_fit_wit_workout_progress_path
    calendar = page.find('div#calendar')
    calendar.click_link :first
    save_and_open_page
  end

end
