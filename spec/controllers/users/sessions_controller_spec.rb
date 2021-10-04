require 'rails_helper'

describe Users::SessionsController, type: :controller  do
  let(:talent) { create(:user, role: 'guest') }
  let(:employer) { create(:user, role: 'employer') }
  let(:recruiter) { create(:user, role: 'recruiter') }

  describe 'Session User' do
    describe 'talent session ' do
      context 'with valid params' do
        let(:params) { { user: { email: talent.email, password: talent.password } } }
        before do
          User.find_by(email: talent.email).update_columns(email_confirmed: true)
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, params: params
        end

        it 'talent should be login succcesfully' do
          expect(response).to have_http_status(:success)
        end

        it 'current user should be equal to login user' do
          expect(@controller.current_user).to eq talent
        end

        it 'talent should be logged out sccussfully' do
          delete :destroy
          expect(@controller.current_user).to be_nil
        end
      end

      context 'with invalid params' do
        let(:params) { { user: { email: talent.email, password: '' } } }
        before do
          User.find_by(email: talent.email).update_columns(email_confirmed: true)
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, params: params
        end

        it 'talent should not be login' do
          expect(response).to have_http_status(401)
        end

        it 'should be show warning' do
          warning = JSON.parse(response.body)['alert']
          expect(warning).to eql 'Invalid email or password.'
        end
      end
    end

    describe 'employer session' do
      context 'with valid params' do
        let(:params) { { user: { email: employer.email, password: employer.password } } }
        before do
          User.find_by(email: employer.email).update_columns(email_confirmed: true)
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, params: params
        end

        it 'employer should be login succcesfully' do
          expect(response).to have_http_status(:success)
        end

        it 'current user should be equal login user' do
          expect(@controller.current_user).to eq employer
        end

        it 'employer should be logged out sccussfully' do
          delete :destroy
          expect(@controller.current_user).to be_nil
        end
      end

      context 'with invalid params' do
        let(:params) { { user: { email: employer.email, password: '' } } }
        before do
          User.find_by(email: employer.email).update_columns(email_confirmed: true)
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, params: params
        end

        it 'employer should not be login' do
          expect(response).to have_http_status(401)
        end

        it 'should be show warning' do
          warning = JSON.parse(response.body)['alert']
          expect(warning).to eql 'Invalid email or password.'
        end
      end
    end

    describe 'recruiter session' do
      context 'with valid params' do
        let(:params) { { user: { email: recruiter.email, password: recruiter.password } } }
        before do
          User.find_by(email: recruiter.email).update_columns(email_confirmed: true)
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, params: params
        end

        it 'recruiter should be login succcesfully' do
          expect(response).to have_http_status(:success)
        end

        it 'current user should be equal to login user' do
          expect(@controller.current_user).to eq recruiter
        end

        it 'recruiter should be logged out sccussfully' do
          delete :destroy
          expect(@controller.current_user).to be_nil
        end
      end

      context 'with invalid params' do
        let(:params) { { user: { email: recruiter.email, password: '' } } }
        before do
          User.find_by(email: recruiter.email).update_columns(email_confirmed: true)
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, params: params
        end

        it 'recruiter should not be login' do
          expect(response).to have_http_status(401)
        end

        it 'should be show warning' do
          warning = JSON.parse(response.body)['alert']
          expect(warning).to eql 'Invalid email or password.'
        end
      end
    end
  end
end
