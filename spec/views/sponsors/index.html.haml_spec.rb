require 'spec_helper'

describe "sponsors/index.html.haml" do
  before(:each) do
    assign(:sponsors, [
      stub_model(Sponsor,
        :name => "Name",
        :description => "Description",
        :address => "Address",
        :phone => "Phone",
        :url => "Url",
        :img_name => "Img Name",
        :logo_file_name => "Logo File Name",
        :logo_content_type => "Logo Content Type",
        :logo_file_size => 1,
        :logo_style => "Logo Style"
      ),
      stub_model(Sponsor,
        :name => "Name",
        :description => "Description",
        :address => "Address",
        :phone => "Phone",
        :url => "Url",
        :img_name => "Img Name",
        :logo_file_name => "Logo File Name",
        :logo_content_type => "Logo Content Type",
        :logo_file_size => 1,
        :logo_style => "Logo Style"
      )
    ])
  end

  it "renders a list of sponsors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Img Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Logo File Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Logo Content Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Logo Style".to_s, :count => 2
  end
end
