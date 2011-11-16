require "spec_helper"

describe FitWitWorkoutsController do
  describe "routing" do

    it "routes to #index" do
      get("/fit_wit_workouts").should route_to("fit_wit_workouts#index")
    end

    it "routes to #new" do
      get("/fit_wit_workouts/new").should route_to("fit_wit_workouts#new")
    end

    it "routes to #show" do
      get("/fit_wit_workouts/1").should route_to("fit_wit_workouts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/fit_wit_workouts/1/edit").should route_to("fit_wit_workouts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/fit_wit_workouts").should route_to("fit_wit_workouts#create")
    end

    it "routes to #update" do
      put("/fit_wit_workouts/1").should route_to("fit_wit_workouts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/fit_wit_workouts/1").should route_to("fit_wit_workouts#destroy", :id => "1")
    end

  end
end
