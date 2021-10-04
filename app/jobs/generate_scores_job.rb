class GenerateScoresJob < ActiveJob::Base
  require 'httparty'

  self.queue_adapter = :sidekiq
  queue_as :default

  TOP_MATCHING_JOBS_SIZE = 8.freeze

  @@token = ""

  def perform(params)
    batch_size = 100
    @@token = get_token
    current_user = params[:current_user]
    job_id = params[:job_id]
    person_id = params[:person_id]
    with_apply = params[:with_apply]
    resume_text = person_id.present? ? Person.find(person_id)&.resume_text : ''
    if job_id.present? && person_id.present?
      # return unless resume_text.present?
      MatchScore.where(job_id: job_id, person_id: person_id).delete_all
      score = get_score_from_resume(job_id, resume_text) 
      MatchScore.create(job_id: job_id, person_id: person_id, score: score > 25 ? score : 25)
    elsif job_id.present? && !person_id.present?
      HTTParty.post(
          "#{ENV['MATCH_SCORE_COMPUTE_SERVICE_URL']}/api/v1/match_scores/generate_scores",
          body: { job_id: job_id }
      )
    elsif person_id.present? && !job_id.present?
      match_score_status = MatchScoreStatus.find_or_create_by(person_id: person_id)
      if match_score_status.completed?
        match_score = MatchScore.where(job_id: job_id, person_id: person_id)
        set_top_matched_jobs(person_id, with_apply, current_user)
      else
        MatchScore.where(person_id: person_id).delete_all
        match_score_status.in_progress!
        get_scores_from_resume(resume_text, person_id)
        match_score_status.completed!
        set_top_matched_jobs(person_id, with_apply, current_user)
      end
    end
  end

  def get_score_from_resume(job_id, resume_text)
    return 25.0 if resume_text.nil? || resume_text == ''

    p "Calling ML API to get MatchScore for job : " + job_id.to_s

    result = HTTParty.post(
      "#{ENV['ML_SERVICE_BASE_URL']}/api/v2/model/bytextandtext/",
      :body => {job_text: Job.find(job_id).inspect.to_s, resume_text: resume_text},
      :headers => { Authorization: "Token " + @@token }
    )

    p "Receieved response for score from ML API"
    p result

    rescue HTTParty::Error => e
      return 25.0
    else
      if result.code == 403
        @@token = get_token
        get_score_from_resume(job_id, resume_text)
      else
        return result.parsed_response["valuation"].present? ? result.parsed_response["valuation"] : 0
      end
  end

  def get_scores_from_resume(resume_text, person_id)
    return 25.0 if resume_text.present?

    result = HTTParty.post(
      "#{ENV['ML_SERVICE_BASE_URL']}/api/v2/model/jobtopnbytext/",
      :body => { top_n: Job.count, resume_text: resume_text },
      :headers => { Authorization: 'Token ' + @@token }
    )

    if result.code == 403
      @@token = get_token
      get_scores_from_resume(resume_text)
    else
      generate_match_scores_from_result(result.parsed_response['top_n'], person_id)
    end
  rescue HTTParty::Error => e
    25.0
  end

  def generate_match_scores_from_result(jobs, person_id)
    jobs_valuations = jobs.pluck('job_id', 'valuation')
    # match_scores = jobs_valuations.map { |job_valuation| { person_id: person_id, job_id: job_valuation.first, score: job_valuation.last } }
    match_scores = jobs_valuations.map { |job_valuation| { person_id: person_id, job_id: job_valuation.first, score: 25.0 } }
    MatchScore.create(match_scores)
  end

  def get_token
    result = HTTParty.post(
      "#{ENV['ML_SERVICE_BASE_URL']}/api-token-auth/",
      :body => { "username": ENV.fetch('ML_API_USER'), "password": ENV.fetch('ML_API_PASS') }
    )

    p "Receieved response for token request from ML API"
    p result

    rescue HTTParty::Error => e
      p e
      return ""
    else
      return result["token"]
  end

  def set_top_matched_jobs(person_id, with_apply, current_user)
    person = Person.find(person_id)
    score_value = SystemConfiguration.find_by('name = ?', Job::SCORE_NAME)&.value
    top_matched_jobs = Job.top_matched_jobs(person_id, score: score_value).limit(TOP_MATCHING_JOBS_SIZE)
    match_score_hash  = MatchScore.where(job_id: top_matched_jobs.pluck(:id), person_id: person_id).pluck(:job_id, :score).to_h
    top_jobs = top_matched_jobs.map { |job| job.to_hash.tap { |job_hash| job_hash[:score] = match_score_hash[job.id] } }
    ApplyToAllMatchingJobsService.new(person, current_user).call if with_apply
    broadcast_top_jobs(person, top_jobs)
  end

  def broadcast_top_jobs(person, top_jobs)
    TopMatchingJobsChannel.broadcast_to(person, {
      top_matching_jobs: top_jobs
    })
  end
end

