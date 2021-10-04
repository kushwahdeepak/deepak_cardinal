
require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:owner) { create(:user, role: :employer) }
  let(:new_owner) { create(:user, role: :employer) }
  let(:users) { create_list(:user, 5) }

  describe 'create' do
    let(:organization) { build(:organization, owner: owner) }

    it 'creates organization successfully' do
      expect(organization.save).to be_truthy
    end

    it 'adds members to an organization successfully' do
      organization.users = users
      expect(organization.save).to be_truthy
      expect(organization.users.count).to eql(5)
      expect(organization.users.map(&:id)).to eql(users.map(&:id))
    end
  end

  describe 'update' do
    let(:organization) { create(:organization, name: 'Some name', owner: owner, users: users) }

    it 'updates organization sucessfully' do
      expect(organization.update(name: 'New name', owner: new_owner)).to be_truthy
      expect(organization.name).to eql('New name')
      expect(organization.owner).to eql(new_owner)
    end

    it 'removes a members from an organization' do
      organization.update(user_ids: users.last(3).map(&:id))
      expect(organization.users.count).to eql(3)
      expect(organization.users.pluck(:id)).to eql(users.last(3).map(&:id))
    end
  end

  describe 'destroy' do
    let!(:organization) { create(:organization, owner: owner) }

    it 'removes an organization' do
      expect{
        organization.destroy
      }.to change { Organization.count }.from(1).to(0)
    end
  end
end
