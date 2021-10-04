require "rails_helper"

RSpec.describe IntakeBatchesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/intake_batches").to route_to("intake_batches#index")
    end

    it "routes to #new" do
      expect(get: "/intake_batches/new").to route_to("intake_batches#new")
    end

    it "routes to #show" do
      expect(get: "/intake_batches/1").to route_to("intake_batches#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/intake_batches/1/edit").to route_to("intake_batches#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/intake_batches").to route_to("intake_batches#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/intake_batches/1").to route_to("intake_batches#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/intake_batches/1").to route_to("intake_batches#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/intake_batches/1").to route_to("intake_batches#destroy", id: "1")
    end
  end
end
