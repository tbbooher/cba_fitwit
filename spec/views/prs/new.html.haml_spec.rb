require 'spec_helper'

describe "prs/new.html.haml" do
  before(:each) do
    assign(:pr, stub_model(Pr,
      :score => "MyString",
      :user_note => "MyString",
      :rxd => false,
      :common_value => 1.5
    ).as_new_record)
  end

  it "renders new pr form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => prs_path, :method => "post" do
      assert_select "input#pr_score", :name => "pr[score]"
      assert_select "input#pr_user_note", :name => "pr[user_note]"
      assert_select "input#pr_rxd", :name => "pr[rxd]"
      assert_select "input#pr_common_value", :name => "pr[common_value]"
    end
  end
end
