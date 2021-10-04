require 'rails_helper'

describe 'MatchScores', type: :request do
  let!(:user) { FactoryBot.create(:user, role: :employer) }
  before {  sign_in(user) }

  describe 'matched_jobs' do
    it 'list top matched jobs for person' do
      FactoryBot.create(:person, user_id: user.id)
      get "/match_scores/talent/#{user.id}"
      result= JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(result['success']).to eq(true)
    end

    it 'should list none when no person found' do
      get "/match_scores/talent/#{user.id}"
      result= JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(result['success']).to eq(false)
    end
  end
end