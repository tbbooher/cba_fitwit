require 'spec_helper'

describe "meetings/edit.html.haml" do
  before(:each) do
    @meeting = assign(:meeting, stub_model(Meeting))
  end

  it "renders the edit meeting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => meetings_path(@meeting), :method => "post" do
    end
  end
end
