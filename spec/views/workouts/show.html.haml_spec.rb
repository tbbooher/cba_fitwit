require 'spec_helper'

describe "workouts/show.html.haml" do
  before(:each) do
    @workout = assign(:workout, stub_model(Workout,
      :score => "Score",
      :user_note => "User Note",
      :rxd => false,
      :common_value => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Score/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/User Note/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
  end
end
