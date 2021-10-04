class InterviewSchedule < ApplicationRecord
  PER_PAGE = 10
  # Associations
  belongs_to :job
  belongs_to :person
  belongs_to :user, optional: true
  has_many :interview_feedbacks
  validates :job_id, presence: true 
  validates :interview_date, presence: true
  validates :interview_time, presence: true
  validates :interview_type, presence: true
  validates :person_id, presence: true

  # Scope
  default_scope { where(active: true) } # do not list canceled interviews
  scope :by_interviewer, ->(id) { where("? = ANY(ARRAY[interviewer_ids]::int[])", id).order(interview_date: :desc) }
  scope :closed_interview, -> { where(active: false) }

  def cancel
    update_columns(active: false)
  end

  def send_emails_to_candidate(interview_time)
    @interview_time = interview_time
    find_date_time
    find_company_details
    person_fullname
    content = OutgoingEmailsHelper.inviting_candidate(@person_fullname, job.name, interview_date.strftime('%m/%d/%Y'), @reformat_interview_time, @org_name, self.job_id, @org_id)
    subject = 'Interview Invitation'

    params = {
      recipient_email: person.email_address,
      sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
      subject: subject,
      content: content,
      email_type: "email_person_invitation_for_interview"
    }

    Rails.logger.info "outgoing_mail_params #{params}"
    OutgoingMailService.send_email_params params
  end

  def send_emails_to_recruiter
    find_date_time
    find_recruiter
    find_company_details
    person_fullname
    content = OutgoingEmailsHelper.inviting_recruiter(@recruiter_fullname, @person_fullname, job.name, interview_date.strftime('%m/%d/%Y'), @reformat_interview_time, @org_name, self.job_id, @org_id)
    subject = 'Interview Invitation'

    params = {
      recipient_email: @recruiter_email,
      sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
      subject: subject,
      content: content,
      email_type: "email_person_invitation_for_interview"
    }

    Rails.logger.info "outgoing_mail_params #{params}"
    OutgoingMailService.send_email_params params
  end

  def reschedule_email_to_candidate(interview_time)
    @interview_time = JSON.parse(interview_time)
    find_date_time
    find_company_details
    person_fullname
    content = OutgoingEmailsHelper.reschedule_invitation_to_candidate(@person_fullname, job.name, interview_date.strftime('%m/%d/%Y'), @reformat_interview_time, @org_name, self.job_id, @org_id)
    subject = 'Reschedule Interview'

    params = {
      recipient_email: person.email_address,
      sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
      subject: subject,
      content: content,
      email_type: "email_person_invitation_for_interview"
    }

    Rails.logger.info "outgoing_mail_params #{params}"
    OutgoingMailService.send_email_params params
  end

  def reschedule_email_to_recruiter
    find_date_time
    find_recruiter
    person_fullname
    find_company_details
    person_fullname
    content = OutgoingEmailsHelper.reschedule_invitation_to_recruiter(@recruiter_fullname, @person_fullname, job.name, interview_date.strftime('%m/%d/%Y'), @reformat_interview_time, @org_name, self.job_id, @org_id)
    subject = 'Reschedule Interview'

    params = {
      recipient_email: @recruiter_email,
      sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
      subject: subject,
      content: content,
      email_type: "email_person_invitation_for_interview"
    }

    Rails.logger.info "outgoing_mail_params #{params}"
    OutgoingMailService.send_email_params params
  end


  def send_cancel_email_to_candidate
    interview_time_send_on_cancel_email
    find_company_details
    person_fullname
    content = OutgoingEmailsHelper.cancel_email_for_candidate(@person_fullname, job.name, self.interview_date.strftime('%m/%d/%Y'), @cancel_time, @org_name, self.job_id, @org_id)
    subject = 'Interview Cancelled'

    params = {
      recipient_email: person.email_address,
      sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
      subject: subject,
      content: content,
      email_type: "email_person_invitation_for_interview"
    }

    Rails.logger.info "outgoing_mail_params #{params}"
    OutgoingMailService.send_email_params params
  end

  def send_cancel_email_to_recruiter
    find_recruiter
    interview_time_send_on_cancel_email
    find_company_details
    person_fullname
    content = OutgoingEmailsHelper.cancel_email_for_recruiter(@recruiter_fullname, @person_fullname, job.name, self.interview_date.strftime('%m/%d/%Y'), @cancel_time, @org_name, self.job_id, @org_id)
    subject = 'Interview Cancelled'

    params = {
      recipient_email: @recruiter_email,
      sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
      subject: subject,
      content: content,
      email_type: "email_person_invitation_for_interview"
    }

    Rails.logger.info "outgoing_mail_params #{params}"
    OutgoingMailService.send_email_params params
  end

  def find_date_time
    format_interview_time = []
    for i in 0...@interview_time&.length
      inter_time = @interview_time[i]
      format_interview_time << "#{inter_time["hour"]}:#{inter_time["minute"]} #{inter_time["isAM"]} #{inter_time["timeZone"]}"
    end
    format_interview_time.to_s
    @reformat_interview_time = format_interview_time.to_s.gsub('["', '').gsub('"]','').gsub('",', '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;')
  end

  def interview_time_send_on_cancel_email
    interview_time = JSON.parse(self.interview_time)
    inter_time = interview_time[0]
    @cancel_time = "#{inter_time["hour"]}:#{inter_time["minute"]} #{inter_time["isAM"]} #{inter_time["timeZone"]}"
  end

  def find_recruiter
    recruiter = User.find(self.scheduler_id)
    @recruiter_email = recruiter.email
    @recruiter_fullname = recruiter.first_name+' '+recruiter.last_name
  end

  def find_company_details
    organization = User.find(self.scheduler_id).organization
    @org_id = organization.id
    @org_name = organization.name
  end

  def person_fullname
    first_name = person&.first_name == 'undefined' ? '' : person&.first_name
    last_name = person&.last_name == 'undefined' ? '' : person&.last_name
    @person_fullname = first_name+' '+last_name
  end

  def self.extract(page: 1, per_page: 5, month:Time.now.month, user:user, own_interview:false, keyword:keyword)
    year = Time.now.year
    user = User.find(user)
    organization = user.organization
    if organization.present?
      orgnization_user_id = organization.users
        interviews = InterviewSchedule.joins(:person, :job).select(attributes)
                     .where('extract(month from interview_date) = ? And extract(year from interview_date) = ?', month,year)
                     .where.not("people.first_name = ? AND people.last_name = ?", 'undefined', 'undefined')
                     .where(organization_id:user.organization.id).order(interview_date: :asc)
        interviews = filter_by_keyword(interviews,keyword) if keyword.present?
        interview_dates = interviews.pluck(:interview_date).uniq
        ints = []
        interview_dates.map do |idate|
          i_data = {}
          i_data[:date] = idate.strftime("%A,%d %b %Y")
          i_data[:data] = interviews.where(interview_date: idate)
          ints << i_data
        end
        interviews = ints
    else
      interviews = []
    end
  end

  def self.filter_by_keyword(interviews, keyword)
    interviews.where('jobs.name ILIKE :search OR people.first_name ILIKE :search OR people.last_name ILIKE :search OR interview_schedules.interview_type ILIKE :search', search: "%#{keyword}%")
  end

  def self.attributes
    "
       people.first_name,
       people.last_name,
       people.school,
       people.location,
       people.email_address,
       people.phone_number,
       people.avatar_url,
       interview_schedules.id,
       interview_schedules.person_id,
       interview_schedules.interview_date,
       interview_schedules.description,
       interview_schedules.job_id ,
       interview_schedules.interview_type,
       interview_schedules.send_email,
       interview_schedules.send_invite_link,
       interview_schedules.interview_time,
       interview_schedules.interviewers,
       jobs.name AS job_title
     "
  end
end
