require 'spec_helper'

describe "locations/index.html.haml" do
  before(:each) do
    assign(:locations, [
      stub_model(Location,
        :name => "Name",
        :description => "Description",
        :directions => "Directions",
        :contact_info => "Contact Info",
        :city => "City",
        :franchise_id => 1,
        :us_state => "Us State",
        :short_description => "Short Description",
        :zip => "Zip",
        :street_address => "Street Address",
        :lat => "9.99",
        :lon => "9.99"
      ),
      stub_model(Location,
        :name => "Name",
        :description => "Description",
        :directions => "Directions",
        :contact_info => "Contact Info",
        :city => "City",
        :franchise_id => 1,
        :us_state => "Us State",
        :short_description => "Short Description",
        :zip => "Zip",
        :street_address => "Street Address",
        :lat => "9.99",
        :lon => "9.99"
      )
    ])
  end

  it "renders a list of locations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Directions".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Contact Info".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "City".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Us State".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Short Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Zip".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Street Address".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
