class FetchSubmittedCandidatesService
  PEOPLE_PER_PAGE = 25.freeze
  MATCH_SCORE_NAME = "person_match_score"
  require 'will_paginate/array'

  attr_reader :result_response

  def initialize(job_id, page, stage, search_params, current_user, period_key, email_type_params)
    @job_id = job_id
    @page   = page
    @stage  = stage
    @search_params = search_params
    @campaign_owner = current_user
    @period_key = period_key
    @email_type_params = email_type_params
  end

  def call
    fetch_candidates
    set_paginated_response
  end

  private

  def fetch_candidates
    fetch_submitted_candidates
    set_candidates_array
  end

  def fetch_submitted_candidates
    @search_params[:user_id] = @campaign_owner.id
    search = PeopleSearch.create(@search_params)

    if @stage == Person::ACTIVE_CANDIDATES
      @submitted_candidates = Person.where(active: true)

    else
      submitted_candidates_ids = job.submissions.joins(:person).pluck(:person_id)
      candidates_ids = submitted_candidates_ids - contacted_candidates_ids
      organization_id = @campaign_owner.organization&.id
      match_score_value = SystemConfiguration.find_by(name: MATCH_SCORE_NAME)&.value || 0

      @submitted_candidates = Person.joins("LEFT JOIN match_scores ON match_scores.person_id = people.id AND match_scores.job_id = #{job.id} AND match_scores.score = #{match_score_value}")
                                  .joins("LEFT JOIN submissions ON submissions.person_id = people.id AND submissions.job_id = #{job.id}")
                                  .joins("LEFT JOIN stage_transitions ON stage_transitions.submission_id = submissions.id AND stage_transitions.id = (SELECT MAX(stage_transitions.id) FROM stage_transitions WHERE stage_transitions.submission_id = submissions.id)")
                                  .where(id: candidates_ids, stage_transitions: { stage: @stage }).order("match_scores.score DESC NULLS LAST")

    end

    @submitted_candidates = search.search_filter_for_ats(@submitted_candidates, @email_type_params)&.paginate(per_page: PEOPLE_PER_PAGE, page: @page) if @submitted_candidates.present?
  end

  def contacted_candidates_ids
    organization_id = @campaign_owner&.organization_id
    (organization_id.present? && @period_key.present?) ? CampaignRecipient.find_contacted_recipients(
                                                       organization_id, @period_key
                                                     ).pluck(:recipient_id) : []
  end

  def set_candidates_array
    @submitted_candidates_list = @submitted_candidates&.map(&:to_hash)
    @submitted_candidates_list&.each { |candidate|
      submission = Submission.where(person_id: candidate[:id], job_id: job.id).first
      last_stage = submission&.stage_transitions&.order('created_at ASC')&.last
      candidate[:stage] = last_stage&.stage
      candidate[:score] = MatchScore.find_by(person_id: candidate[:id], job_id: job.id)&.score
      last_contacted_recipient = CampaignRecipient.where(
                                  organization_id: User.find_by(id: candidate[:user_id])&.organization&.id,
                                  recipient_id: candidate[:id]
                                ).order('contact_recipient_at DESC').first
      candidate[:resume_grade] = ResumeGrade.find_by(person_id: candidate[:id])&.resume_grade
      candidate[:last_contacted] = last_contacted_recipient&.contact_recipient_at
      person = Person.find(candidate[:id])
      candidate[:resume] = Rails.env.test? ? Rails.application.routes.url_helpers.url_for(person.resume) : person.resume.service_url if person.resume.attached?
    }
  end

  def set_paginated_response
    @result_response = {
      submitted_candidates: @submitted_candidates_list,
      total_count: @submitted_candidates.class == WillPaginate::Collection ? @submitted_candidates.total_entries : @submitted_candidates.count,
      total_pages: @submitted_candidates.present? ?  @submitted_candidates&.total_pages : 0
    }
  end

  def job
    @job ||= Job.find(@job_id)
  end
end
