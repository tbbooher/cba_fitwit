require 'spec_helper'

describe "FitWitWorkouts" do
  describe "GET /fit_wit_workouts" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get fit_wit_workouts_path
      response.status.should be(200)
    end
  end
end
