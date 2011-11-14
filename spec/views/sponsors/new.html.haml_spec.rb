require 'spec_helper'

describe "sponsors/new.html.haml" do
  before(:each) do
    assign(:sponsor, stub_model(Sponsor,
      :name => "MyString",
      :description => "MyString",
      :address => "MyString",
      :phone => "MyString",
      :url => "MyString",
      :img_name => "MyString",
      :logo_file_name => "MyString",
      :logo_content_type => "MyString",
      :logo_file_size => 1,
      :logo_style => "MyString"
    ).as_new_record)
  end

  it "renders new sponsor form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sponsors_path, :method => "post" do
      assert_select "input#sponsor_name", :name => "sponsor[name]"
      assert_select "input#sponsor_description", :name => "sponsor[description]"
      assert_select "input#sponsor_address", :name => "sponsor[address]"
      assert_select "input#sponsor_phone", :name => "sponsor[phone]"
      assert_select "input#sponsor_url", :name => "sponsor[url]"
      assert_select "input#sponsor_img_name", :name => "sponsor[img_name]"
      assert_select "input#sponsor_logo_file_name", :name => "sponsor[logo_file_name]"
      assert_select "input#sponsor_logo_content_type", :name => "sponsor[logo_content_type]"
      assert_select "input#sponsor_logo_file_size", :name => "sponsor[logo_file_size]"
      assert_select "input#sponsor_logo_style", :name => "sponsor[logo_style]"
    end
  end
end
