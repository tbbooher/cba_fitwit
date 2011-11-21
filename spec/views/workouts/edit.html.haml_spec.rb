require 'spec_helper'

describe "workouts/edit.html.haml" do
  before(:each) do
    @workout = assign(:workout, stub_model(Workout,
      :score => "MyString",
      :user_note => "MyString",
      :rxd => false,
      :common_value => 1.5
    ))
  end

  it "renders the edit workout form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => workouts_path(@workout), :method => "post" do
      assert_select "input#workout_score", :name => "workout[score]"
      assert_select "input#workout_user_note", :name => "workout[user_note]"
      assert_select "input#workout_rxd", :name => "workout[rxd]"
      assert_select "input#workout_common_value", :name => "workout[common_value]"
    end
  end
end