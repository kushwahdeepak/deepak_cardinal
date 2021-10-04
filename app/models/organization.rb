class Organization < ApplicationRecord
  include Discard::Model
  include Discardable::Organization

  PENDING = 'pending'.freeze
  APPROVED = 'approved'.freeze
  DECLINED = 'declined'.freeze
  RESULTS_PER_PAGE = 25

  # Associations
  belongs_to :owner, class_name: 'User'
  has_many :jobs, dependent: :destroy
  has_many :users
  has_many :campaign_recipients
  has_many :invitations, dependent: :destroy
  has_many :employer_dashboards

  has_many :sub_organizations, class_name: 'Organization', foreign_key: 'member_organization_id'
  belongs_to :member_organization, optional: true, class_name: 'Organization', foreign_key: 'member_organization_id'

  has_many :recruiter_organizations, dependent: :destroy
  has_many :members, through: :recruiter_organizations, source: :user # get organization members

  # Validations
  validates :owner, presence: true
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  validates :description, presence: true

  # Scopes
  default_scope -> { kept } # default
  scope :created_at_date, -> (date) { where(created_at: date.beginning_of_day..date.end_of_day)}
  scope :pending, -> { where(status: PENDING) }
  scope :today_pending, -> {pending.today}
  scope :approved, -> {where(status: APPROVED)}
  scope :search, ->(pattern) { joins(:owner).where('users.email ~* :pattern OR organizations.name ~* :pattern', pattern: pattern) }
  scope :today, -> {where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)}
  scope :by, -> (status: 'all'){where(status: status) unless status.eql?('all')}

  # Callbacks
  after_update :send_approval_email_to_user, if: :status_changed?

  # Class methods
  def self.metadata(total: 1, page: 1)
    status_count_hash =  self.group(:status).count.to_hash || {}
    status_count_hash.merge(
      {
        total_organization: total,
        today_pending_organization: Organization.today_pending.count,
        region_count:   Organization.new.send(:prepare_data, raw_hash: Organization.all.group(:region).count   ),
        industry_count: Organization.new.send(:prepare_data, raw_hash: Organization.all.group(:industry).count ),
        total_pages: (total%RESULTS_PER_PAGE == 0 ? total/RESULTS_PER_PAGE : total/RESULTS_PER_PAGE + 1),
        current_count: (total <= RESULTS_PER_PAGE) ? total : RESULTS_PER_PAGE * page

      }
    ).symbolize_keys
  end

  def self.upload_image_to_s3(logo)
    begin
      credentials = Aws::Credentials.new(ENV['BUCKETEER_AWS_ACCESS_KEY_ID'], ENV['BUCKETEER_AWS_SECRET_ACCESS_KEY'])
      s3 = Aws::S3::Resource.new(region:'us-east-2', credentials: credentials)
      obj = s3.bucket('cardinaltalent-prod').object(logo.original_filename)
      obj.put(body: logo.tempfile, acl: 'public-read')
    rescue
      raise 'failed to upload'
    end
    obj
  end

  def self.employer_organization_status(user)
    if user.employer? and user.organization.present?
      return (user.organization.status == Organization::APPROVED) ?  Organization::APPROVED : Organization::PENDING
    end
    Organization::PENDING
  end
  
  # Instance methods

  def invitation(inviting_user)
    Invitation.where(organization_id: self.id, inviting_user_id: inviting_user.id)
  end

  def is_cardinal_organization
    return true if self.member_organization.present? || self.name == 'CardinalTalent' 
    false
  end

  def status_changed?
    self.previous_changes[:status]
  end

  def send_approval_email_to_user
   
    @organization = Organization.find_by(id: self.id)
    @user = User.find_by(id: self.owner_id)
   
    content = OutgoingEmailsHelper.approve_reject_organization(@organization,@user)
    subject = "Organization #{@organization.status}"
    
    params = {
      recipient_email: @user.email,
      sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
      subject: subject,
      content: content,
      email_type: "email_user_inviting_to_organization"
    }
    OutgoingMailService.send_email_params params
  end

  def organization_delete_notify(user,oranization_name)
    content = OutgoingEmailsHelper.organization_delete(user,oranization_name)
    subject = "Organization Deleted"
    params = {
      recipient_email: user.email,
      sender_email: ENV.fetch('OUTGOING_EMAIL_USERNAME'),
      subject: subject,
      content: content,
      email_type: "email_user_inviting_to_organization"
    }
    OutgoingMailService.send_email_params params
  end

  def email
    owner&.email
  end

  def is_official_email?(owner_email: '')
    email_domain = owner_email.gsub(/.+@([^.]+).+/, '\1') # regex to get domain of gmail
    return self.website_url.include?(email_domain)
  end

  private

  def prepare_data(raw_hash: {})
    raw_hash.map { |key, val|
      next {name: 'others', value: val} if key.blank?
      {name: key, value: val}
    }
  end
end
