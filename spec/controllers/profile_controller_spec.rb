require 'rails_helper'

describe 'ProfileController', type: :request do
  let(:user) { create(:user) }
  let(:person) { create(:person, user: user) }
  before { sign_in(user) }

  describe 'PUT User/profile/:id' do
    context 'update person profile' do
      let(:params) do
        { person: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          skills: 'C++, Javascript',
          location: 'Locationtest',
          employer: 'TestCompany',
          school: 'Test Institute',
          title: 'Test position',
          description: 'Test description'
        } }
      end

      before do
        put "/users/profile/#{person.id}", params: params
        person.reload
      end

      it 'respsonse should be successfull' do
        expect(response.status).to eq 200
      end

      it 'updated person with all attributes' do
        expect(person.first_name).to eql(params[:person][:first_name])
        expect(person.last_name).to eql(params[:person][:last_name])
        expect(person.skills).to eql(params[:person][:skills])
        expect(person.location).to eql(params[:person][:location])
        expect(person.employer).to eql(params[:person][:employer])
        expect(person.school).to eql(params[:person][:school])
        expect(person.title).to eql(params[:person][:title])
        expect(person.description).to eql(params[:person][:description])
      end
    end

    context 'create job experience for person' do
      let(:job_exps) do
        { title: "Quod iusto error atque.",
          description: "Dolores ab itaque consequuntur.",
          start_date: "2021-08-11",
          end_date: "2021-08-16",
          person_id: person.id,
          company_name: 'Test  Company',
          location: 'Test Location',
          present: false }
      end

      let(:params) do
        { person: {
          experiences: [job_exps].to_json
        } }
      end

      let(:action) do
        put "/users/profile/#{person.id}", params: params
        person.reload
      end

      it 'created job experience successfully' do
        expect { action }.to change { person.job_experiences.count }.by(1)
      end
    end

    context 'update job experience for person' do
      let(:job_exp) { FactoryBot.create(:job_experience, person: person) }

      let(:update_exps) do
        { id: job_exp.id,
          title: "Quod iusto error atque.",
          description: "Dolores ab itaque consequuntur.",
          start_date: "2021-08-11",
          end_date: "2021-08-16",
          person_id: person.id,
          company_name: 'Test  Company',
          location: 'Test Location',
          present: false }
      end

      let(:params) do
        { person: {
          experiences: [update_exps].to_json
        } }
      end

      before do
        put "/users/profile/#{person.id}", params: params
        person.reload
      end

      let(:updated_experience) do
        JobExperience.find_by(id: job_exp.id)
      end

      it 'updated job experiences with all attributes successfully' do
        json_parse = JSON.parse(params[:person][:experiences])[0]
        expect(updated_experience.title).to eql json_parse['title']
        expect(updated_experience.description).to eql json_parse['description']
        expect(updated_experience.start_date).to eql json_parse['start_date'].to_date
        expect(updated_experience.end_date).to eql json_parse['end_date'].to_date
        expect(updated_experience.person_id).to eql json_parse['person_id']
        expect(updated_experience.company_name).to eql json_parse['company_name']
        expect(updated_experience.location).to eql json_parse['location']
        expect(updated_experience.present).to eql json_parse['present']
      end
    end

    context 'remove job experience for person' do
      let(:job_exp) { FactoryBot.create(:job_experience, person: person) }
      let(:params) do
        { person: {
          remove_exp_id: [job_exp.id].to_json
        } }
      end
      before do
        put "/users/profile/#{person.id}", params: params
        person.reload
      end

      let(:removed_exp) do
        JobExperience.find_by(id: job_exp.id)
      end

      it 'removed successfully' do
        expect(removed_exp).to be_nil
      end
    end
  end
end
