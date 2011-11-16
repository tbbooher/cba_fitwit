require 'spec_helper'

describe "fit_wit_workouts/edit.html.haml" do
  before(:each) do
    @fit_wit_workout = assign(:fit_wit_workout, stub_model(FitWitWorkout,
      :name => "MyString",
      :description => "MyString",
      :units => "MyString",
      :score_method => "MyString"
    ))
  end

  it "renders the edit fit_wit_workout form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => fit_wit_workouts_path(@fit_wit_workout), :method => "post" do
      assert_select "input#fit_wit_workout_name", :name => "fit_wit_workout[name]"
      assert_select "input#fit_wit_workout_description", :name => "fit_wit_workout[description]"
      assert_select "input#fit_wit_workout_units", :name => "fit_wit_workout[units]"
      assert_select "input#fit_wit_workout_score_method", :name => "fit_wit_workout[score_method]"
    end
  end
end
