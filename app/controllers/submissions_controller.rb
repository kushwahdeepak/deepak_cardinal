class SubmissionsController < ApplicationController
  include Pundit
  include IncomingMailsHelper
  include SubmissionEmailHelper

  def create
    submission = Submission.create_submission(current_user, submission_params)
    if submission.is_a?(Submission)
      if submission_params[:submission_type] == Submission::LEAD
        submission.change_stage(feedback: Submission::LEAD)
      else
        submission.change_stage(feedback: 'applicant', stage: StageTransition::APPLICANTS)
        send_mails_about_appliying_to_a_job(submission: submission)
      end

      # We have to update job applied date into referrals table if user apply from referral link.
      update_job_applied_date_from_referral_link

      render json: { submission: submission.as_json(only: %i[id job_id]) }
    else
      render json: { error: submission }, status: 422
    end
  end

  def apply_to_all_matching_jobs
    render json: { error: 'Not Authorized' }, status: 401 unless current_user || current_user.talent? || current_user.person_id.present?

    Job.joins(:match_scores).where(match_scores: {person_id: current_user.person_id}).where('match_scores.score >= 70').map{|e| e.id}.each do |id|
      existing_submission = Submission.where(job_id: id, user_id: current_user.id, person_id: current_user.person_id)[0]
      unless existing_submission
        submission = Submission.create!(job_id: id, user_id: current_user.id, person_id: current_user.person_id)
        Note.create!(user: submission.user, body: submission.to_s, person: submission.person)
      end

      send_mails_about_appliying_to_a_job(submission: existing_submission || submission)
    end

    render json: { message: 'Success' }, status: :ok
  end

  def change_stage
    params[:candidate_ids]&.each do |id|
      submission = Submission.find_by(person_id: id, job_id: params[:job_id])
      unless submission.present?
         #Its need for moving candidates from leads/Active candidates
         params[:submission][:person_id] = id
        submission = Submission.create!(candidate_params)
        Note.create!(user: submission.user, body: submission.to_s, person: submission.person)
      end
      submission.change_stage(feedback: 'Test', stage: params[:stage])
    end
    render json: { message: 'Success' }, status: :ok
  end

  # def reject(feedback)
  #   stage_transitions = submissions.map do |submission|
  #     authorize submission
  #     submission.change_stage(feedback: feedback, stage: StageTransition::REJECT)
  #   end

  #   render status: :ok, json: { stage_transitions: stage_transitions }
  # end

  def my_submissions
    person = Person.find_by(email_address: current_user&.email)
    @submissions = person.submissions.includes(:job, :user) if person.present?
  end

  def applied_jobs_list
    person = Person.find_by(email_address: current_user&.email)
    if person.present?
      if (attr = params[:appled_job_search].select{|key, value| value.present? }).present?
        submissions_results =  attr[:keyword].present? ?  person.submissions.includes([{:job=>:organization}]).references([{:job=>:organization}])
                                                  .where("LOWER(jobs.name) LIKE :keyword 
                                                  OR LOWER(organizations.name) LIKE :keyword 
                                                  OR LOWER(organizations.city) LIKE :keyword 
                                                  OR LOWER(organizations.country) LIKE :keyword 
                                                  OR LOWER(organizations.region) LIKE :keyword", 
                                                  keyword: "%#{attr[:keyword].downcase}%") : []                                            
        @submissions = submissions_results.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
      else
        @submissions = person.submissions.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
      end
      jobs_total_count = submissions.total_entries
      total_pages = submissions.total_pages
      @submissions = submissions.map { |submissions| JSON.parse(
          submissions.to_json(
            {:include => 
              {:job => 
                {
                  :include => { 
                      :organization => {:only => [:name,:city,:country,:region]} 
                  },:only => [:id,:name,:organization_id,]
                }
              }
            }
          )
        )}
      render json: { submissions: @submissions, total_pages: total_pages, total_count: jobs_total_count  }
    end
  end

  def self.to_html submission
    job_desc = submission.job.present? ?  helpers.link_to(submission.job.name, "/jobs/#{submission.job.id}") : "unknown"
    person_desc = submission.person.present? ? helpers.link_to(submission.person.email_address, "/people/#{submission.person.id}") : "unknown"
    r_val = ''
    if submission.incoming_mail.present? #if submission was created by incoming_mail
      incoming_mail_link = helpers.link_to 'original email', "/incoming_mails/#{submission.incoming_mail.id}"
      r_val += "Candidate #{person_desc} was submitted to the job #{job_desc} through linkedin (#{incoming_mail_link}) on #{submission.created_at.to_date}."
    else #or was it created by a recruiter using ui
      user_desc = helpers.link_to submission.user.email, "users/#{submission.user.id}"
      r_val += "Candidate #{person_desc} was submitted to the job #{job_desc} by #{user_desc} on #{submission.created_at.to_date}."
    end
    if submission&.person&.ranking.present?
      r_val += "  Ranking: top #{submission.person.ranking}."
    end
    r_val
  end

  # def move_to_applicant_stage(stage, id)
  #   stage_transitions = []
  #   @submission = Submission.new(candidate_params)
  #   @submission.person_id = id
  #   authorize @submission
  #   if @submission.save
  #     Note.create!(user: @submission.user, body: @submission.to_s, person: @submission.person)

  #     stage_transition = StageTransition.new(feedback: 'Test', stage: stage, submission_id: @submission.id)
  #     if stage_transition.save
  #       stage_transitions << stage_transition.id
  #     end
  #   end
  #   @submissions = Job.find_by(id: params[:job_id])&.submissions.as_json(include: [:stage_transitions])

  #   render status: :ok, json: { stage_transitions: StageTransition.where(id: stage_transitions).as_json, submissions: @submissions }
  # end

  def destroy
    my_submissions
    @submission = Submission.find(params[:id])
    @submission.destroy
    
    respond_to do |format|
      format.js
    end
  end
  
  private

  def submissions
    @submissions ||= Submission.where(id: params[:submssions_ids])
  end

  def submission_params
    params
      .require(:submission)
      .permit(:user_id, :person_id, :job_id, :submission_type)
  end

  def candidate_params
    params.require(:submission).permit(:user_id, :person_id, :job_id)
  end

  def update_job_applied_date_from_referral_link
    if session[:referral_token].present?
      Referral.update_job_applied_date(session[:referral_token])
      session.delete(:referral_token)
    end
  end

end
