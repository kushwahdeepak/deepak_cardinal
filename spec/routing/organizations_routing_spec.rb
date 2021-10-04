require "rails_helper"

RSpec.describe OrganizationsController, type: :routing do
  let(:owner) { create(:user, role: 'employer') }
  let(:organization) { create(:organization, owner: owner, name: 'Some org name') }
  before { sign_in(owner) }
  describe "routing" do
    context 'with valid route url' do
      it 'access organization profile /careers page' do
        expect(get("/organizations/#{organization.id}/careers")).to route_to(controller: 'organizations', action: 'company_profile', id: organization.id)
      end
    end
    context 'with invalid route url and request' do
      it 'invalid route request' do
        expect(post("/organizations/#{organization.id}/careers")).not_to be_routable
      end

      it 'invalid route url redirect 404' do
        expect(get("/organizations/233432210463/careers")).not_to route_to(controller: 'organizations', action: 'company_profile', id: organization.id)
      end
    end
  end
end
