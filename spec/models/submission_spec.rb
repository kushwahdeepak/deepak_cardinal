
require 'rails_helper'

RSpec.describe Submission, type: :model do
  before :each do
    @user = User.create!(email: 'example@aol.coxm', password: '1234567!', password_confirmation: '1234567!', accepts: true, accepts_date: Date.today, role: 'recruiter')
    @person = Person.create!({location: 'San Francisco', email_address: SecureRandom.uuid, user: @user})
    @job = Job.create!
    @incoming_mail = IncomingMail.create!({})
  end

  describe  :find_by_user_and_job do
    it 'finds the right submission' do
      sub1 = Submission.create!( user: @user, person: @person, job: @job )
      sub2 = Submission.create!( user: @user, person: @person, job: @job )
      job2 = Job.create!
      sub3 = Submission.create!( user: @user, person: @person, job: job2 )
      res = Submission.find_by_person_and_job @person.id, @job.id

      expect(res.id).to eq sub2.id
    end

  end



  describe 'constructor' do
    it 'connects all the associations' do
      sub = Submission.new( user: @user, person: @person, job: @job )
      sub.save!
      expect(@user.submissions.first.id).to be sub.id
      expect(@person.submissions.first.id).to be sub.id
      expect(@job.submissions.first.id).to be sub.id
    end

    it 'rejects records with both user and incoming_mail' do
      expect { Submission.create!( user: @user, person: @person, job: @job, incoming_mail: @incoming_mail) }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it 'rejects records with neither user or incoming_mail' do
      expect { Submission.create!(  person: @person, job: @job) }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it 'accepts records with user as creator' do
      Submission.create!( user: @user, person: @person, job: @job )
    end
    it 'accepts records with incoming_mail as creator' do
      Submission.create!(person: @person, job: @job , incoming_mail: @incoming_mail)
    end
  end

  describe '#get_stage' do
    it 'return submission\'s current stage' do
      sub = Submission.new( user: @user, person: @person, job: @job )
      sub.save!
      expect(sub.get_stage).to be_nil
      create(:stage_transition, submission: sub, stage: StageTransition::OFFER)
      create(:stage_transition, submission: sub, stage: StageTransition::REJECT)
      expect(sub.get_stage.stage).to eq StageTransition::OFFER
    end
  end

  describe '#change_stage' do
    it 'return newly created dst stage' do
      sub = Submission.new( user: @user, person: @person, job: @job )
      sub.save!
      stage_transition = sub.change_stage(feedback: 'test')
      expect(stage_transition.feedback).to eq 'test'
      expect(stage_transition.stage).to eq StageTransition::APPLICANTS
      expect(sub.get_stage.stage).to eq StageTransition::APPLICANTS
    end
  end
end
