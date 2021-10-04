class Job < ApplicationRecord
  include EsJobSearch
  include PgSearch::Model
  include Discard::Model
  include Discardable::Job

  attr_accessor :document_file_name

  # constants
  SCORE_NAME = 'job_match_score'.freeze
  EXPIRATION_PERIOD_DAYS = 30
  RESULTS_PER_PAGE = 25

  # Enums
  enum status: {pending: 0, active: 1, block: 2, expired: 3}

  # Associations
  belongs_to :user, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :managed_account, optional: true
  belongs_to :organization

  has_one :people_search
  has_one_attached :logo
  has_one :job_stage_status, dependent: :destroy
  has_one :employer_dashboard

  has_many :submissions, inverse_of: :job, dependent: :destroy
  has_many :recruiter_updates
  has_many :submitted_requests
  has_many :submitted_candidates, dependent: :nullify
  has_many :job_searches
  has_many :jobs_locations
  has_many :locations, through: :jobs_locations
  has_many :match_scores, dependent: :destroy
  has_many :resume_grades
  has_many :referrals, dependent: :destroy
  has_many :interview_schedules, dependent: :destroy
  has_many :company_profile_jobs
  has_many :company_profiles, through: :company_profile_jobs
  has_many :user_education_jobs
  has_many :user_educations, through: :user_education_jobs

  # nested form attributes
  accepts_nested_attributes_for :job_searches, allow_destroy: true

  # Scopes
  scope :top_matched_jobs, -> (person_id, score: 0) do
    joins(:match_scores)
      .where("match_scores.person_id = ? AND match_scores.score > ?", person_id, score)
      .order('match_scores.score DESC')
  end

  scope :created_at_date, -> (date) { where(created_at: date.beginning_of_day..date.end_of_day)}
  scope :with_eager_loaded_logo, -> { eager_load(logo_attachment: :blob) }
  scope :with_preloaded_logo, -> {preload(logo_attachment: :blob)}
  scope :search_job_with_keyword, ->(job_keyword) { where('jobs.name ILIKE ?', "%#{job_keyword}%") }
  scope :filter_by, ->(organizations: []) { where(organization_id: organizations) unless organizations.empty?}
  scope :by, ->(status: 'all') { where(status: status,active: true) unless status.present? and status == 'all'}
  scope :active_only, -> { where(active: true)}
  default_scope -> { kept }

  # pg search scope
  pg_search_scope :search_by_keyword, against: {name: 'A', skills: 'B', description: 'C', organization_id: 'D'}, using: {tsearch: {prefix: true}}

  def self.search_by(keyword: '', param: {})
    unless keyword.blank?
      return search_by_keyword(param[:query]).filter_by(organizations: param[:organization] || []).by(status: param[:status] || 'all').active_only().page(param[:page]).per(RESULTS_PER_PAGE)
    end
    filter_by(organizations: param[:organization] || []).by(status: param[:status] || 'all').page(param[:page]).active_only().per(RESULTS_PER_PAGE)
  end

  # aggregate jobs by department
  def self.searialize(organization_id: nil)
    job_hash = {}
    jobs = Job.by(status:'active').where(organization_id: organization_id)
    jobs.each do |job|
      key = job.department.present? ? job.department : 'Other Openings'
      value = {title: job.name, location: job.location || 'USA'}
      unless job_hash.key?(key)
        job_hash[key] = [] << value
        next
      end
      job_hash[key] << value
    end
    return job_hash
  end

  def inspect
    to_hash
  end

  def to_hash
    {
      id: id,
      name: name,
      location: location,
      description: description,
      skills: skills,
      niceToHaveSkills: nice_to_have_skills,
      notificationemails: notificationemails,
      referral_amount: referral_amount,
      referral_candidate: referral_candidate,
      subject: email_campaign_subject,
      email_desc: email_campaign_desc,
      sms_desc: sms_campaign_desc,
      keywords: keywords,
      nice_to_have_keywords: nice_to_have_keywords,
      education_preference: school_names,
      school_names: user_educations,
      company_preference: company_names,
      company_names: company_profiles,
      location_preference: location_preference,
      location_names: locations,
      experience_years: experience_years,
      prefered_titles: prefered_titles,
      prefered_industries: prefered_industries,
      department: department,
      creator_id: creator_id,
      portalcompanyname: portalcompanyname,
      portalcity: portalcity,
      compensation: compensation,
      work_time: work_time,
      gen_reqs: gen_reqs,
      pref_skills: pref_skills,
      benefits: benefits,
      created_at: created_at,
      expiry_date: expiry_date,
      logo: self.organization_logo,
      organization: self.organization&.name,
      status: status,
    }
  end

  def organization_logo
      organization&.image_url
  end

  # return hash of jobs_id with there leads count
  def self.jobs_lead_metrics(campaign_owner_id, job_id, latest_date = DateTime.now.to_date + 1.day)
    search = PeopleSearch.new
    people_to_exclude = search.get_excluded_people(campaign_owner_id, job_id, "")
    organization_id = User.find(campaign_owner_id).own_organization&.id
    query = self.joins("LEFT JOIN match_scores ON (match_scores.job_id = jobs.id)")
            .joins("LEFT JOIN people ON (people.id = match_scores.person_id)")
            .where("people.skills IS NOT NULL AND people.skills != '' AND people.skills != '[]'")
            .where("people.organization_id IS NULL OR people.organization_id = ?", organization_id)
            .where("jobs.id = ? AND match_scores.score >= ? AND match_scores.score <= ? AND match_scores.created_at <= ?", job_id, MatchScore::LEADS_MINIMUM_SCORE, MatchScore::LEADS_MAXIMUM_SCORE, latest_date)
    query = query.where.not("people.id IN (?)", people_to_exclude) if people_to_exclude.count > 0
    query.count
  end


  def location_search
    locations.map { |location|
      [location.country, location.state, location.city]
    }
  end

  def create_search_people
    people_search.present? ? people_search : self.create_people_search!(
      company_names: remove_punctuation(company_names), schools: remove_punctuation(school_names),
      titles: remove_punctuation(name), experience_years: experience_years, skills: remove_punctuation(skills),
      locations: remove_punctuation(get_locations)
    )
  end

  def update_search_people
    people_search.nil? ? create_search_people : people_search.update(
      company_names: remove_punctuation(company_names), schools: remove_punctuation(school_names),
      titles: remove_punctuation(name), experience_years: experience_years, skills: remove_punctuation(skills),
      locations: remove_punctuation(get_locations)
    )
  end

  def remove_punctuation(str)
    str.gsub(/^,[[:punct:]]/, '') if str.present?
  end

  def has_default_image?
    is_audio?
    is_plain_text?
    is_excel?
    is_word_document?
    is_pdf?
  end

  # If the uploaded content type is an audio file,
  # return false so that we'll skip audio post processing
  def apply_post_processing?
    if self.has_default_image?
      return false
    else
      return true
    end
  end

  def applicants_count_for_stage(stage)
    submissions.joins(:stage_transitions)
      .where('stage_transitions.stage = ?
        AND stage_transitions.id = (SELECT id FROM stage_transitions
        WHERE stage_transitions.submission_id = submissions.id
        ORDER BY ID DESC LIMIT 1)', stage
      ).count
  end

  def job_post_live_email(user,job)
    content = OutgoingEmailsHelper.job_post_success(user,job)
    subject = "Job Post"
    params = {
      recipient_email: user.email,
      sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
      subject: subject,
      content: content,
      email_type: "email_user_inviting_to_organization"
    }
    OutgoingMailService.send_email_params params
  end

  def job_post_pending_email(user,job)
    content = OutgoingEmailsHelper.job_post_review(user,job)
    subject = "Job Post"
    params = {
      recipient_email: user.email,
      sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
      subject: subject,
      content: content,
      email_type: "email_user_inviting_to_organization"
    }
    OutgoingMailService.send_email_params params
  end

  EXPIRATION_PERIOD_DAYS = 30

  def self.expire_jobs
    jobs = where("created_at < ? and status = ?", EXPIRATION_PERIOD_DAYS.days.ago, :active)
    jobs.update_all(status: :expired)
  end

  private
  
    def get_organization_name
      organization&.name
    end
end
