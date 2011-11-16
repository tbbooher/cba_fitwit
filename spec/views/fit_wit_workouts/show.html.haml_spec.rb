require 'spec_helper'

describe "fit_wit_workouts/show.html.haml" do
  before(:each) do
    @fit_wit_workout = assign(:fit_wit_workout, stub_model(FitWitWorkout,
      :name => "Name",
      :description => "Description",
      :units => "Units",
      :score_method => "Score Method"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Units/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Score Method/)
  end
end
