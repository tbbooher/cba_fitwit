require "spec_helper"

describe PrsController do
  describe "routing" do

    it "routes to #index" do
      get("/prs").should route_to("prs#index")
    end

    it "routes to #new" do
      get("/prs/new").should route_to("prs#new")
    end

    it "routes to #show" do
      get("/prs/1").should route_to("prs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/prs/1/edit").should route_to("prs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/prs").should route_to("prs#create")
    end

    it "routes to #update" do
      put("/prs/1").should route_to("prs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/prs/1").should route_to("prs#destroy", :id => "1")
    end

  end
end
