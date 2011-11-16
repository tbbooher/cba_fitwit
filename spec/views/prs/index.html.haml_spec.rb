require 'spec_helper'

describe "prs/index.html.haml" do
  before(:each) do
    assign(:prs, [
      stub_model(Pr,
        :score => "Score",
        :user_note => "User Note",
        :rxd => false,
        :common_value => 1.5
      ),
      stub_model(Pr,
        :score => "Score",
        :user_note => "User Note",
        :rxd => false,
        :common_value => 1.5
      )
    ])
  end

  it "renders a list of prs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Score".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "User Note".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
