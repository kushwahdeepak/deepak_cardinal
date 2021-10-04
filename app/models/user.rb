require 'google/apis/gmail_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'signet/oauth_2/client'
require 'fileutils'
require 'net/http'
require 'uri'
require 'json'
require 'action_view'

class User < ApplicationRecord
  include Discard::Model

  ACTIVE_SEEKER = 'Yes, I am actively searching for a job'.freeze
  OPEN_TO_NEW_OPPORTUNITIES = 'No, but I am open to the right opportunity'.freeze
  NOT_INTERESTED = 'No, I am just browsing'.freeze

  enum role: [:guest, :member, :moderator, :admin, :talent, :employer, :recruiter, :third_party_recruiter, :internal_recruiter]
  enum active_job_seeker: {
    active_seeker: ACTIVE_SEEKER,
    open_to_new_opportunities: OPEN_TO_NEW_OPPORTUNITIES,
    not_interested: NOT_INTERESTED
  }

  ROLES = {
    admin: 'admin',
    recruiter: 'recruiter',
    guest:'guest',
    employer: 'employer',
    talent: 'talent',
    third_party_recruiter: 'third_party_recruiter',
    internal_recruiter: 'internal_recruiter'
  }.freeze

  # Scopes
  scope :admins, -> { where(role: :admin) }
  scope :created_at_date, -> (date) { where(created_at: date.beginning_of_day..date.end_of_day)}
  scope :without_role, -> (role) { where.not(role: role) }
  scope :search, -> (pattern) { where('email ~* :pattern OR first_name ~* :pattern OR last_name ~* :pattern', pattern: pattern)}

  before_create :confirmation_token

  after_update :send_approval_email_to_user, if: :user_role_changed?
  after_update :create_admin_for_user, if: :user_role_changed_to_admin?
  default_scope -> { kept }

  def user_role_changed?
    self.previous_changes[:role]
  end

  def user_role_changed_to_admin?
    self.previous_changes[:role]&.last == 'admin'
  end

  def send_approval_email_to_user
    AdministrativeMailer.email_to_user_about_approval(user: self).deliver_now
  end

  def inspect
    {
      id:id,
      email:email,
      role:role,
      created_at:created_at,
      first_name: first_name,
      last_name: last_name
    }
  end

  has_many :people_searches, inverse_of: :user, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_one :person, dependent: :destroy, foreign_key: :person_id
  has_many :submissions, inverse_of: :user, dependent: :destroy
  has_many :searched_candidates, inverse_of: :user, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :received_requests, class_name: 'Contact', foreign_key: 'target_user_id', dependent: :nullify
  has_many :interview_feedbacks
  has_many :referrals, class_name: 'Referral', foreign_key: 'inviter_id', dependent: :destroy
  has_one :admin, class_name: 'Admin', foreign_key: :user_id, dependent: :destroy

  include ActionView::Helpers::NumberHelper

  class << self
    def current_user=(user)
      Thread.current[:current_user] = user
    end
    def current_user
      Thread.current[:current_user]
    end
  end
  def recent_notes_count
    notes.count  #todo make this more specific
  end
  def recent_candidate_contributions
    people.count
  end
  self.primary_key = 'id'

  include Sidekiq::Worker
  sidekiq_options retry: false


  acts_as_followable
  acts_as_follower
  acts_as_messageable

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules
  devise :invitable, :database_authenticatable, :registerable, :lockable, :recoverable, :rememberable, :trackable, :token_authenticatable, :omniauthable, omniauth_providers: %i[facebook github google_oauth2 gplus linkedin twitter]

  validates :email, presence: true
  validates_uniqueness_of :email, case_sensitive: false
  has_many :recruiter_organizations, dependent: :destroy
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :password, length: { in: 8..128}, on: :create

  validates :calendly_link, url: true, allow_blank: true

  delegate :age, to: :identity, allow_nil: true
  has_many :posts, dependent: :destroy
  has_many :private_messages, class_name: 'Private::Message'
  has_many  :private_conversations,
  foreign_key: :sender_id,
  class_name: 'Private::Conversation'
  has_many :group_messages, class_name: 'Group::Message'
  has_and_belongs_to_many :group_conversations, class_name: 'Group::Conversation'
  belongs_to :organization, optional: true

  has_many :job_searches, dependent: :destroy
  has_many :jobs, through: :organization
  has_one :own_organization, class_name: 'Organization', dependent: :destroy, foreign_key: :owner_id

  before_save { self.role ||= :guest }


  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def password_required?
    password.blank?
  end

  def sync_person_to_user
    person = Person.find_by_email(email)
    person.update(user: self) if person.present? && person.user.nil?
  end

  def saved_candidate_for(person)
    SavedCandidate.where(person_id: person.id, user_id: self.id).first
  end

  def submitted_candidate_for(person)
    SubmittedCandidate.where(person_id: person.id, user_id: self.id).first
  end

  # TODO: Write a helper method that lets us look up submitted candidates
  # by the recipient, instead of by the person record

  def flagged_candidate_for(person)
    FlaggedCandidate.where(person_id: person.id, user_id: self.id).first
  end

  def followed_candidate_for(person)
    FollowedCandidate.where(person_id: person.id, user_id: self.id).first
  end

  def mailboxer_name
    self.name
  end

  def mailboxer_email(object)
    self.email
  end


  def self.find_for_oauth(auth, signed_in_resource = nil)
    data = auth.info

    user = User.where(email: auth.info.email).first

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # # If a signed_in_resource is provided it always overrides the existing user
    # # to prevent the identity being locked with accidentally created accounts.
    # # Note that this may leave zombie accounts (with no associated identity)
    # # which need to be cleaned up at a later date.
    # #TODO: clean up zombie accounts (with no associated identity)
    # user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user, if needed
    if user.nil?
      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided, we assign a temporary email and ask
      # the user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(email: email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.where(
          name: auth.extra.raw_info.name ? auth.extra.raw_info.name : auth.info.name,
          first_name: auth.extra.raw_info.first_name ? auth.extra.raw_info.first_name : auth.info.first_name,
          last_name: auth.extra.raw_info.last_name ? auth.extra.raw_info.last_name : auth.info.last_name,
          provider: auth.provider ? auth.provider : auth.info.provider,
          uid: auth.uid ? auth.uid : auth.info.uid,
          username: auth.info.nickname ? auth.info.nickname : auth.info.uid,
          location: auth.extra.raw_info.location ? auth.extra.raw_info.location : auth.info.location,
          email: auth.info.email ? auth.info.email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          # password: Devise.friendly_token[0,20],
          accepts: true,
          accepts_date: Date.current,
          public_profile_url: auth.extra.raw_info.public_profile_url ? auth.extra.raw_info.public_profile_url : auth.info.public_profile_url,
          api_standard_profile_request: auth.extra.raw_info.api_standard_profile_request ? auth.extra.raw_info.api_standard_profile_request : auth.info.api_standard_profile_request,
          industry: auth.extra.raw_info.industry ? auth.extra.raw_info.industry : auth.info.industry,
          current_share: auth.extra.raw_info.current_share ? auth.extra.raw_info.current_share : auth.info.current_share,
          num_connections: auth.extra.raw_info.num_connections ? auth.extra.raw_info.num_connections : auth.info.num_connections,
          num_connections_capped: auth.extra.raw_info.num_connections_capped ? auth.extra.raw_info.num_connections_capped : auth.info.num_connections_capped,
          summary: auth.extra.raw_info.summary ? auth.extra.raw_info.summary : auth.info.summary,
          specialties: auth.extra.raw_info.specialties ? auth.extra.raw_info.specialties : auth.info.specialties,
          positions: auth.extra.raw_info.positions ? auth.extra.raw_info.positions : auth.info.positions,
          picture_url: auth.extra.raw_info.picture_url ? auth.extra.raw_info.picture_url : auth.info.picture_url,
          site_standard_profile_request: auth.extra.raw_info.site_standard_profile_request ? auth.extra.raw_info.site_standard_profile_request : auth.info.site_standard_profile_request
        ).first_or_initialize

        # user.skip_confirmation!
        user.save!(validate: false)

      end
    end

    # Associate the identity with the user, if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end

    user
  end

  def update_with_password(params, *options)
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = if params[:password].blank? || valid_password?(current_password)
      update_attributes(params, *options)
    else
      self.assign_attributes(params, *options)
      self.valid?
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end

    clean_up_passwords
    result
  end

  def followed_candidate_for(person)
    followed_candidates.where(person_id: person.id).first
  end

  def resume
    return unless person&.resume&.attached?
    person&.resume.blob
  end

  def signuprole_with_employer?
    signuprole == "employer"
  end

  def alchemy_roles
    if admin?
      %w(admin)
    else
      []
    end
  end

  def alchemy_display_name
    "#{firstname} #{lastname}".strip
  end

  def remember_me
    read_attribute(:remember_me)
  end

  attr_accessor :remember_me

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  APPLICATION_NAME = Rails.application.secrets.application_name
  SCOPE = 'userinfo.email, https://www.googleapis.com/auth/gmail.send, userinfo.profile'

  def self.from_omniauth(auth, user)
    where(email: auth.info.email).first_or_initialize do |user|
      user.name = auth.info.name
      user.email = auth.info.email
    end
  end

  def self.authentication(linked_account)
    auth = Signet::OAuth2::Client.new(
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: Rails.application.secrets.token_credential_uri,
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret,
      scope: User::SCOPE,
      redirect_uri: Rails.application.secrets.redirect_uri,
      refresh_token: linked_account[:refresh_token]
    )
    # if linked_account.token_updated_at <= 58.minutes.ago
    if auth.fetch_access_token!
      linked_account.update!(token: auth.access_token, refresh_token: auth.refresh_token, expires_at: auth.expires_at)
      return auth
    else
      return false
    end
  end

  # to fetch refresh token from serverAuthCode
  def get_refresh_token_for_device(serverAuthCode)
    data = {
            client_id: Rails.application.secrets.google_client_id,
            client_secret: Rails.application.secrets.google_client_secret,
            grant_type: "authorization_code",
            code: serverAuthCode,
            redirect_uri: Rails.application.secrets.redirect_uri
          }
    request = Net::HTTP.post_form(URI.parse('https://accounts.google.com/o/oauth2/token'), data)
    response = JSON(request.body)
    return response
  end

  def all_organizations
    return [] if organization.nil?
    all_org_ids = [organization.id]
    Organization.where(id: all_org_ids)
  end

  def self.fetch_emails_from_gmail(linked_account, date=nil)
    gmail = User.get_gmail_service(linked_account)
    if gmail
      after = date.present? ? date : linked_account.created_at.to_date - 3
      query = "after: #{after}"
      email_list = gmail.list_user_messages(linked_account[:uid], q: "#{query}")

      email_array = parse_messages(email_list, gmail)
      emails = Email.add(email_array, linked_account)
      emails
    else
      return false
    end
  end

  def self.get_gmail_service(linked_account)
    auth = User.authentication(linked_account)

    if auth
      gmail = Google::Apis::GmailV1::GmailService.new
      gmail.client_options.application_name = APPLICATION_NAME
      gmail.authorization = auth
      gmail
    else
      return false
    end
  end

  # to fetch emails in every 10 minutes interval - for cron job
  def self.refresh_all_linked_accounts
    if User.count > 0
      User.all.each do |user|
        if user.linked_accounts.present?
          last_email = user.emails.order('created_at desc').first
          user.linked_accounts.each do |linked_account|
            date = linked_account.emails.last.received_at.to_date if linked_account.emails.present?
            begin
              User.fetch_emails_from_gmail(linked_account, date)
            rescue Exception => e
              next
            end
          end
        end
      end
    end
  end

  class AccessToken
    attr_reader :token
    def initialize(token)
      @token = token
    end

    def apply!(headers)
      headers['Authorization'] = "Bearer #{@token}"
    end
  end

  def create_person(resume = nil)
    person = Person.find_by(email_address: email)
    if person.present?
      person.update(user: self)
    else
      person = Person.create!(
        email_address: email, first_name: first_name,
        last_name: last_name, user: self, linkedin_profile_url: linkedin_profile_url,
        resume: resume,phone_number: phone_number,location: location,
        source: Person::SOURCE[:system]
      )
    end
    update(person: person)
    create_admin_for_user if admin?
  end

  def create_admin_for_user
    create_admin!(email: email)
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    self.user_approved = true
    save!(:validate => false)
  end

  def user_approved?
    return true if self.user_approved.nil?
    self.user_approved
  end

  private

  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end
end
