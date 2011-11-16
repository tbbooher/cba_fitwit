require 'spec_helper'

describe "fit_wit_workouts/index.html.haml" do
  before(:each) do
    assign(:fit_wit_workouts, [
      stub_model(FitWitWorkout,
        :name => "Name",
        :description => "Description",
        :units => "Units",
        :score_method => "Score Method"
      ),
      stub_model(FitWitWorkout,
        :name => "Name",
        :description => "Description",
        :units => "Units",
        :score_method => "Score Method"
      )
    ])
  end

  it "renders a list of fit_wit_workouts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Units".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Score Method".to_s, :count => 2
  end
end
