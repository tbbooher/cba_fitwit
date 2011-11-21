require 'spec_helper'

describe "friends/index.html.haml" do
  before(:each) do
    assign(:friends, [
      stub_model(Friend,
        :name => "Name"
      ),
      stub_model(Friend,
        :name => "Name"
      )
    ])
  end

  it "renders a list of friends" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
