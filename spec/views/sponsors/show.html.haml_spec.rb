require 'spec_helper'

describe "sponsors/show.html.haml" do
  before(:each) do
    @sponsor = assign(:sponsor, stub_model(Sponsor,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Address/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Phone/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Url/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Img Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Logo File Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Logo Content Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Logo Style/)
  end
end
