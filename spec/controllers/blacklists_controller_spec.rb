require 'rails_helper'

describe BlacklistsController, type: :controller do
  let(:employer) { create(:user, role: :employer) }
  let(:candidate) { create(:user, role: :talent) }
  let(:person) { create(:person, user: candidate) }

  describe 'unsubscribe' do
    context 'without blacklisted before' do
      it 'creates blacklist successfully' do
        expect {
          get :unsubscribe, params: { person_id: person.id, user_id: employer.id }
        }.to change { Blacklist.count }.from(0).to(1)
      end
    end

    context 'with blacklisted before' do
      before { create(:blacklist, user: employer, person: person) }

      it 'does not create blacklist' do
        expect {
          get :unsubscribe, params: { person_id: person.id, user_id: employer.id }
        }.not_to change { Blacklist.count }
      end
    end
  end
end
