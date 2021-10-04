require 'rails_helper'

describe 'OrganizationController', type: :request do
  let(:owner) { create(:user, role: :employer) }

  before {  sign_in(owner) }

  describe 'create' do
    let(:users) { create_list(:user, 5) }
    let(:params) { { organization: { name: 'Test org', description: 'Test' } } }

    it 'creates organization successfully' do
      expect {
        post '/organizations', params: params
      }.to change { Organization.count }.by(1)

      expect(response).to redirect_to(organizations_path)
      expect(owner.own_organization).not_to be_nil
      expect(owner.own_organization.name).to include('Test org')
    end
  end

  describe 'update' do
    let(:new_owner) { create(:user, role: :employer) }
    let(:users) { create_list(:user, 5) }
    let(:organization) { create(:organization, owner: owner, users: users, name: 'Some org name') }
    let(:params) { { organization: { name: 'New org name' } } }

    it 'updates organization successfully' do
      put "/organizations/#{organization.id}", params: params
      organization.reload
      expect(organization.name).to eql('New org name')
      expect(response).to redirect_to(organizations_path)
    end
  end

  describe 'delete' do
    let(:users) { create_list(:user, 5) }
    let!(:organization) { create(:organization, owner: owner, users: users, name: 'Some org name') }

    it 'deletes organization successfully' do
      expect {
        delete "/organizations/#{organization.id}"
      }.to change { Organization.count }.from(1).to(0)
      expect(response).to redirect_to(organizations_path)
    end
  end

  describe 'attempt do update an orgnization with other owner' do
    let(:other_owner) { create(:user, role: :employer) }
    let(:users) { create_list(:user, 5) }
    let(:organization) { create(:organization, owner: other_owner, users: users, name: 'Some org name') }
    let(:params) { { organization: { name: 'New org name', user_ids: users.last(3).pluck(:id) } } }

    it 'gives warning message that current user lacks authorizations on updating' do
      put "/organizations/#{organization.id}", params: params
      organization.reload
      expect(organization.name).to eql('Some org name')
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'attempt do delete an orgnization with other owner' do
    let(:other_owner) { create(:user, role: :employer) }
    let(:users) { create_list(:user, 5) }
    let!(:organization) { create(:organization, owner: other_owner, users: users, name: 'Some org name') }

    it 'redirects to root path without deleting an organization' do
      expect {
        delete "/organizations/#{organization.id}"
      }.not_to change { Organization.count }
      expect(response).to redirect_to(root_path)
    end
  end
end
