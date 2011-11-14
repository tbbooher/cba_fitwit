require 'spec_helper'

describe "locations/show.html.haml" do
  before(:each) do
    @location = assign(:location, stub_model(Location,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Directions/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Contact Info/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/City/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Us State/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Short Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Zip/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Street Address/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
  end
end
