require File::expand_path('../../spec_helper', __FILE__)

describe "The my_fit_wit section" do

  before(:all) do
    cleanup_database
    create_default_userset
    log_in_as "admin@iboard.cc", 'thisisnotsecret'
    #load_some_camp_history
  end

  it "should show the my_fit_wit page" do
    visit my_fit_wit_index_path
    page.should have_content("Welcome back") 
  end

  it "should load a fitness progress page" do
    visit my_fit_wit_exercise_progress_path 
    current_user.should eq(User) 
    page.should have_content("Calendar")
  end

  it "should load a camp exercise_progress page" do
    visit my_fit_wit_camp_exercise_progress_path
    page.should have_content("Camp report")
  end

  it "should load a goals page" do
    visit my_fit_wit_my_goals_path
    page.should have_content("Set your goals")
  end

end
