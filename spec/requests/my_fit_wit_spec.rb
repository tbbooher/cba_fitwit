require File::expand_path('../../spec_helper', __FILE__)

describe "The my_fit_wit section" do

  before(:all) do
    cleanup_database
    create_default_userset
    #load_some_camp_history
  end

  before(:each) do
    admin_email = "admin@iboard.cc"
    log_in_as admin_email, 'thisisnotsecret'
    @user = User.where(email: admin_email).first
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
    #save_and_open_page
    fill_in "Workout Name", with: "Defend Sparta"
    fill_in "Score", with: "300"
    click_button "Submit"
    page.should have_content("Custom Workout was successfully created.")
    # now check to see if the custom_workout was really created
    u = User.where(email: "admin@iboard.cc").first
    # and how check that we see it on the page . . .
    #u.custom_workouts.all.size.should eq(1)
    u.custom_workouts.first.custom_name.should eq("Defend Sparta")
    page.should have_content("Defend Sparta")
  end

  it "should let a user do a fitwit workout on their own" do
    visit my_fit_wit_fit_wit_workout_progress_path
    calendar = page.find('div#calendar')
    calendar.click_link :first
    # now we are on the subform
    click_button "custom_workout_button"
    second_option_xpath = "//*[@id='custom_workout_fit_wit_workout_id']/option[2]"
    second_option = find(:xpath, second_option_xpath).text
    select second_option, from: "custom_workout_fit_wit_workout_id"
    fill_in "Score", with: "300"
    click_button "Submit"
    page.should have_content("Custom Workout was successfully created.")
    # it needs to display the fit wit workout
    page.should have_content(second_option)
  end

  it "should show you all your previous progress for a workout" do
    # create 10 exertions of the Bob ... the conquest
    workouts = FactoryGirl.build_list(:workout, 10, user: @user)
    visit my_fit_wit_fit_wit_workout_progress_path
    click_link "By workout"
    select :first, from: "fit_wit_workout_id"
  end

end
