require 'spec_helper'

describe "locations/edit.html.haml" do
  before(:each) do
    @location = assign(:location, stub_model(Location,
      :name => "MyString",
      :description => "MyString",
      :directions => "MyString",
      :contact_info => "MyString",
      :city => "MyString",
      :franchise_id => 1,
      :us_state => "MyString",
      :short_description => "MyString",
      :zip => "MyString",
      :street_address => "MyString",
      :lat => "9.99",
      :lon => "9.99"
    ))
  end

  it "renders the edit location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => locations_path(@location), :method => "post" do
      assert_select "input#location_name", :name => "location[name]"
      assert_select "input#location_description", :name => "location[description]"
      assert_select "input#location_directions", :name => "location[directions]"
      assert_select "input#location_contact_info", :name => "location[contact_info]"
      assert_select "input#location_city", :name => "location[city]"
      assert_select "input#location_franchise_id", :name => "location[franchise_id]"
      assert_select "input#location_us_state", :name => "location[us_state]"
      assert_select "input#location_short_description", :name => "location[short_description]"
      assert_select "input#location_zip", :name => "location[zip]"
      assert_select "input#location_street_address", :name => "location[street_address]"
      assert_select "input#location_lat", :name => "location[lat]"
      assert_select "input#location_lon", :name => "location[lon]"
    end
  end
end
