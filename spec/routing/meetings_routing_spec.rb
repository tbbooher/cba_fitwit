require "spec_helper"

describe MeetingsController do
  describe "routing" do

    it "routes to #index" do
      get("/meetings").should route_to("meetings#index")
    end

    it "routes to #new" do
      get("/meetings/new").should route_to("meetings#new")
    end

    it "routes to #show" do
      get("/meetings/1").should route_to("meetings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/meetings/1/edit").should route_to("meetings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/meetings").should route_to("meetings#create")
    end

    it "routes to #update" do
      put("/meetings/1").should route_to("meetings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/meetings/1").should route_to("meetings#destroy", :id => "1")
    end

  end
end
