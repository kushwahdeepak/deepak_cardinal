
require 'rails_helper'

describe Person, type: :model do
  let(:user) { create(:user, :recruiter) }
  let(:person) { create(
    :person,
    user: User.last,
    company_names: 'Amazon',
    phone_number: '123456789',
    email_address: 'example@example.com'
  )}

  describe :deactivate_outdated do
    it 'sets active to false to those candidates whose active_date_at is older than threshold' do
      p_too_old = Person.create!({ email_address: "example@example.com" , user: user })
      p_too_old.update_attributes active_date_at:(Person::EXPIRATION_PERIOD_MONTHS).months.ago - 1.day
      p_ok = Person.create!(email_address: "example1@example.com", user:user)
      p_ok.update_attributes active_date_at:(Person::EXPIRATION_PERIOD_MONTHS).months.ago + 1.day

      expect(Person.deactivate_outdated).to eql 1

      actives = Person.where('active = true')
      expect(actives.size).to eql 1
      expect(actives.first.id).to eql p_ok.id
    end
  end

  describe :create! do
    it('null constraint on email') do
      expect{ Person.create!(user: user) }.to raise_error(ActiveRecord::StatementInvalid, /.+NotNullViolation.+email_address.+/)
    end

    it('unique constraoned on email')do
      Person.create!(email_address: "example@example.com", user: user)
      expect{ Person.create!({ email_address: "example@example.com" , user: user })}.to raise_error(ActiveRecord::StatementInvalid, /.+UniqueViolation.+email_address.+/)
    end

    #todo we have to test that the person is saved to solr
    it "rudimentary" do
      person = Person.create!({ email_address: "example@example.com", tags: 'tag1, tag2', init_note: 'mynote', user: user } )
      expect(person.id).to_not be nil
      expect(person.email_address).to eq "example@example.com"
      expect(person.user).to be user
      expect(user.people[0].id).to eql person.id
      expect(person.active).to eq true
      expect(Person.last.tags).to eq 'tag1, tag2'
      expect(person.notes.size).to eq 2
      expect(person.notes.last.body).to eq 'mynote'
      expect(person.notes.last.user).to be user
      expect(person.notes.first.user).to be user
    end

    it "accepts unonwn params and puts them in the original field as json" do
      person = Person.create!({ email_address: Faker::Internet.email, unknown_param: 'dontknow', user: user })
      expect(person.original).to include 'dontknow'
    end

    it "attaches a resume pdf" do
      resume = fixture_file_upload(Rails.root.join('spec/fixtures/incoming_mails', 'resume.pdf'), 'application/pdf')
      person = Person.create!({ email_address: Faker::Internet.email, resume: resume, user: user })
      expect(person.resume.attached?).to be true
      expect(person.resume_text).not_to be_nil
    end

    it "attaches a resume docx" do
      file = fixture_file_upload(Rails.root.join('spec/fixtures/incoming_mails', 'resume.docx'), 'application/docx')
      person = Person.create!({ email_address: Faker::Internet.email, resume: file, user: user })
      expect(person.resume.attached?).to be true
      expect(person.resume_text).not_to be_nil
    end

    it "attaches a resume doc" do
      resume = fixture_file_upload(Rails.root.join('spec/fixtures/incoming_mails', 'resume.doc'), 'application/doc')
      person = Person.create!({ email_address: Faker::Internet.email, resume: resume, user: user })
      expect(person.resume.attached?).to be true
      expect(person.resume_text).not_to be_nil
    end

    it "attaches a resume txt" do
      resume = fixture_file_upload(Rails.root.join('spec/fixtures/incoming_mails', 'plain.txt'), 'application/txt')
      person = Person.create!({ email_address: Faker::Internet.email, resume: resume, user: user })
      expect(person.resume.attached?).to be true
      expect(person.resume_text).not_to be_nil
      expect(person.top_company).to be true
    end

    it "attaches an avatar" do
      avatar = fixture_file_upload(Rails.root.join('spec/fixtures', 'avatar.jpeg'), 'image/jpeg')
      person = Person.create!({email_address: Faker::Internet.email, avatar: avatar, user: user} )
      expect(person.avatar.attached?).to be true
    end
  end

  describe :create do
    it 'sets the top_company/school_status' do
      expect(Person.create!({ email_address:"abcd@abcd1" , user:user, company_names:'Amazon' }).top_company).to be true
      expect(Person.create!({ email_address:"abcd@abcd2" , user:user, company_names:'GitLab' }).top_company).to be true
      expect(Person.create!({ email_address:"abcd@abcd4" , user:user, school:'Carnegie Mellon University' }).top_school).to be true
      expect(Person.create!({ email_address:"abcd@abcd5" , user:user, company_names:'AkamaiTechnologies GitLab', school:'Carnegie Mellon University' }).top_company).to be true
      expect(Person.create!({ email_address:"abcd@abcd6" , user:user, company_names:'AkamaiTechnologies GitLab', school:'Carnegie Mellon University' }).top_school).to be true
    end
  end

  describe :update do

    it 'sets the top_company/school_status' do
      person.update({ company_names: 'GitLab' })
      expect(person.reload.top_company).to be true
      person.update({ school: 'Northwestern University' })
      expect(person.reload.top_school).to be true
      person.update({ company_names: 'AkamaiTechnologies GitLab' })
      expect(person.reload.top_company).to be true
      expect(person.top_school).to be true
    end

    it 'update the resume_txt' do
      file = fixture_file_upload(Rails.root.join('spec/fixtures/incoming_mails', 'resume.pdf'), 'application/pdf')
      person.update({ resume: file })
      expect(person.reload.resume.attached?).to be true
      expect(person.resume_text).not_to be_nil
    end
  end

  describe :add_note do
    it 'saves the note' do
      p = Person.create!({email_address:"abcd" , user:user} )
      p.add_note 'abc'
      expect(p.notes.size).to eq 2
      expect(p.notes.last.body).to eq 'abc'
    end
  end

  describe :filters do
    it 'filters a phone number' do
      filtered_number = "123-*****-89"
      expect(person.phone_number_filtered).to eq(filtered_number)
    end

    it 'shows that number is not available' do
      person.update(phone_number: nil)

      expect(person.phone_number_filtered).to eq('not available')
    end

    it 'filters an email' do
      filtered_email = "*******@example.com"
      expect(person.email_address_filtered).to eq filtered_email
    end
  end

  describe :links do
    it 'update links' do
      person.update(links: ["https:/github.com/12w31231","https://lever.co/ewrwer"])

      expect(person.reload.links).to eq ["https:/github.com/12w31231","https://lever.co/ewrwer"]
    end

    it 'update github links' do
      person.update(links: ["https:/github.com/12w31231"])

      expect(person.reload.links).to eq ["https:/github.com/12w31231"]
    end

  end

  # todo : move this to person helper spec
  # describe :tag_with_rank do
  #   it "classified candidate as top 20 based on the scool POSITIVE" do
  #     p = Person.create!(email_address:"abcd" , user:user, school: 'Princeton')
  #     p.tag_with_rank
  #     expect(p.tags).to include  Person::TOP_2O_PERCENT_TAG
  #   end
  #   it "classified candidate as top 20 based on the scool. negative" do
  #     p = Person.create!(email_address:"abcd" , user:user, school:"other schol" )
  #     p.tag_with_rank
  #     expect(p.tags).to be nil
  #   end
  # end
end
