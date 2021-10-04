require 'rails_helper'

describe 'UsersController', type: :request do
  before { sign_in(user) }

  describe 'Patch User/:id' do
    let(:user) { create(:user, role: :employer) }
    let(:params) do
      { user: {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        phone_number: Faker::PhoneNumber.cell_phone,
        active_job_seeker: 'Yes, I am actively searching for a job',
        email: Faker::Internet.email
      } }
    end

    context 'update the user' do
      before do
        put "/users/#{user.id}", params: params
        user.reload
      end

      it 'with all attributes' do
        expect(user.first_name).to eql(params[:user][:first_name])
        expect(user.last_name).to eql(params[:user][:last_name])
        expect(user.phone_number).to eql(params[:user][:phone_number])
        expect(user.active_job_seeker).to eql('active_seeker')
      end

      it 'except email' do
        expect(user.email).not_to eql(params[:user][:email])
      end

      it 'response should be successfull' do
        message = (JSON.parse(response.body)['message'])
        expect(message).to eql('Updated Successfully')
        expect(response.status).to eq 200
      end
    end
  end
end
