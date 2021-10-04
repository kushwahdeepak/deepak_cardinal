require 'rails_helper'

describe MyConnectionsController, type: :request do
  let(:employer) { create(:user, role: :employer) }
  let(:contacts) { 3.times{ FactoryBot.create(:contact, user: employer) } }
  let(:new_contact) { create(:contact, user: employer) }


  describe 'my_connections/index' do
    before {  sign_in(employer) }

    it 'index page' do
      get '/my_connections'
      expect(response).to render_template('my_connections/index')
    end

    it "assigns @ var" do
      contacts
      get '/my_connections'
      expect(Contact.all.count).to eq(3)
      expect(assigns(:sent_contact_requests).count).to eq(3)
      expect(assigns(:received_contact_requests).count).to eq(0)
      expect(assigns(:approved_contact_requests).count).to eq(0)
    end

  end

  describe 'my_connections/create' do
    before {  sign_in(employer) }

    let(:params) { {"contacts"=>{"0"=>{"first_name"=>"Sakthi", "last_name"=>"Aps", "email"=>{"0"=>{"address"=>"sakthiaps26@gmail.com", "type"=>"other", "primary"=>"true", "selected"=>"true"}}, "groups"=>["Contacts"], "selectedEmail"=>"undefined", "primaryEmail"=>"", "selectedPhone"=>"undefined", "primaryPhone"=>"", "selectedAddress"=>"null", "primaryAddress"=>"null", "fullName"=>"", "hasValidEmail"=>"undefined", "selectedMail"=>"sakthiaps26@gmail.com", "selectedPhone"=>"", "selectedAddress"=>"", "letter"=>"a"}}, "source"=>"gmail", "owner"=>{"first_name"=>"Sakthi", "last_name"=>"Aps", "external_id"=>"40fee92eb3d08eb7f10af42bddaa29318928022431a3203dee7698b70fd51214", "email"=>{"0"=>{"address"=>"sakthilak.sl@gmail.com"}}, "owner"=>"true"}} }

    it 'create contact successfully' do
      expect{
        post '/my_connections', params: params
      }.to change {Contact.count }.by(1)

      expect(Contact.last.email).to eq('sakthiaps26@gmail.com')
      expect(Contact.last.first_name).to eq('Sakthi')
      expect(Contact.last.last_name).to eq('Aps')
      expect(response.status).to eq(204)
    end
  end

  describe 'Invitation Target user updation' do
    before {  sign_in(employer) }

    let(:new_user) { create(:user, role: :employer) }
    let(:contact) { create(:contact, user: new_user) }

    it 'update received user id if valid receiver' do
      contact.update(email: employer.email)

      expect(contact.reload.target_user_id).to eq(nil)

      get "/my_connections/invite/#{contact.id}"

      expect(contact.reload.target_user_id).to eq(employer.id)

      get '/my_connections'

      expect(assigns(:sent_contact_requests).count).to eq(0)
      expect(assigns(:received_contact_requests).count).to eq(1)
      expect(assigns(:approved_contact_requests).count).to eq(0)

    end

    it 'invalid connection request link' do
      get "/my_connections/invite/#{contact.id}"

      expect(contact.reload.target_user_id).to eq(nil)
    end
  end

  describe 'view/accept connection request when user not login' do
    let(:new_user) { create(:user, role: :employer) }
    let(:contact) { create(:contact, user: new_user) }

    it 'user not authenticated' do
      contact.update(email: employer.email)

      get "/my_connections/invite/#{contact.id}"

      expect(session[:contact_request_id]).to eq(contact.id)
      expect(response).to redirect_to(new_user_session_path)
    end
  end


  describe 'my_connections/update status' do
    before {  sign_in(employer) }

    it 'update status' do
      get "/my_connections/invite/#{new_contact.id}/send"
      expect(new_contact.reload.status).to eq('send')

      get '/my_connections'

      expect(employer.reload.contacts.contact_status(0).count).to eq(1)
      expect(employer.reload.received_requests.contact_status(0).count).to eq(0)
      expect(employer.reload.contacts.contact_status(3).count).to eq(0)
    end

    it 'update send status' do
      new_user = create(:user, role: :employer)
      new_user_contact = create(:contact, user: new_user)
      new_user_contact.update(email: employer.email, target_user_id: employer.id)

      get "/my_connections/invite/#{new_contact.id}/send"

      expect(new_contact.reload.status).to eq('send')

      expect(employer.reload.contacts.contact_status(0).count).to eq(1)
      expect(employer.reload.received_requests.contact_status(0).count).to eq(1)
      expect(employer.reload.contacts.contact_status(3).count).to eq(0)
    end

    it 'update Received status' do
      get "/my_connections/invite/#{new_contact.id}/received"

      expect(new_contact.reload.status).to eq('received')
    end

    it 'update Accepted status' do
      new_user = create(:user, role: :employer)
      new_user_contact = create(:contact, user: new_user)
      new_user_contact.update(email: employer.email, target_user_id: employer.id)

      get "/my_connections/invite/#{new_user_contact.id}/accepted"

      expect(new_user_contact.reload.status).to eq('accepted')

      get '/my_connections'

      expect(assigns(:sent_contact_requests).count).to eq(0)
      expect(assigns(:received_contact_requests).count).to eq(0)
      expect(assigns(:approved_contact_requests).count).to eq(1)
    end

    it 'update Rejected status' do
      get "/my_connections/invite/#{new_contact.id}/rejected"

      expect(new_contact.reload.status).to eq('rejected')
    end

  end

  describe 'unsubscribe' do
    let(:new_user) { create(:user, role: :employer) }

    it "create new unsubscribe" do
      expect{
        get "/my_connections/unsubscribe", params: {email: employer.email}
      }.to change{Unsubscribe.count}.by(1)

      expect{
        get "/my_connections/unsubscribe", params: {email: employer.email}
      }.not_to change { Unsubscribe.count }

      expect{
        get "/my_connections/unsubscribe", params: {email: new_user.email}
      }.to change{Unsubscribe.count}.by(1)
    end
  end


end
