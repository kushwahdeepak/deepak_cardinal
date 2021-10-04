require 'elasticsearch/model'

class Person < ApplicationRecord
  #include ActiveModel::AttributeMethods
  include ActiveModel::Model
  #include PgSearch::Model
  include IncomingMailsHelper
  extend ActiveModel::Callbacks
  extend ActiveModel::Naming

  include EsCandidateSearch
  include EsSearchable


  DEGREE_MASTERS = 'Masters'
  DEGREE_BACHELORS = 'Bachelors'
  DEGREE_DOCTORATE = 'Doctorate'
  DEGREE_CERTIFICATE = 'Certificate'
  TOP_2O_PERCENT_TAG = 'top20percentCandidate'
  TOP_SCHOOL_TAG = 'top_school'
  TOP_COMPANY_TAG = 'top_company'
  ACTIVE_CANDIDATES = "active_candidates"

  # candidate source types
  SOURCE = { system: 'sign_in',
             direct:'direct',
             incoming_mail: 'incoming_mail',
             linkedin: 'linkedin',
             salesql_phone: 'salesql_phone',
             salesql_email: 'salesql_email',
             zoom_info:'zoom_info',
             applicant: 'applicant',
             indeed: 'indeed',
             bulk_upload: 'bulk_upload'}.freeze

  has_one_attached :resume
  has_one_attached :avatar

  serialize :links, Array
  #belongs_to :intake_batch this asssociation is not yeat supported
  has_many :notes, inverse_of: :person, dependent: :destroy
  belongs_to :user, optional: true
  belongs_to :organization, optional: true
  has_many :submissions, dependent: :destroy
  has_many :match_scores, dependent: :destroy
  has_many :campaign_recipients, dependent: :destroy, foreign_key: :recipient_id
  has_many :campaigns, through: :campaign_recipients, foreign_key: :campaign_id
  has_one :resume_grade
  has_many :job_experiences, dependent: :destroy
  has_many :education_experiences, dependent: :destroy
  has_many :user_emails, class_name: 'EmailAddress', dependent: :destroy
  has_many :phone_numbers, inverse_of: :person, dependent: :destroy
  has_many :interview_schedules, dependent: :destroy

  validates :first_name, :last_name, :email_address, presence: true
  validates :phone_number, format: { with: /\A\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})\z/, message: "wrong format" }

  after_save :index_person

  def phone_number_filtered
    unless phone_number.nil?
      num_digits = phone_number.gsub(/[^0-9]/, '')
      first_part = num_digits[0...3]
      last_part = num_digits.last(2)
      "#{first_part}-*****-#{last_part}"
    else
      "not available"
    end
  end

  def email_address_filtered
    if email_address
      splitted_email_address = email_address.split("@")
      splitted_email_address[0]&.gsub(/[a-zA-Z0-9]/, '*') + "@#{splitted_email_address[1]}"
    end
  end

  def self.find_by_email(email)
    person = Person.find_by(email_address: email)
    person.present? ? person : nil
  end

  def add_note body
    self.notes << Note.create!(body: body, person: self)
  end
  def name
    (first_name || '') + ' ' + (last_name||'')
  end

  def index_person
    if active
      __elasticsearch__.index_document
    end
  end

  def update params
    self.notes << Note.new(
      user: params[:user],
      body: "Updated candidate record."
    )
    if params[:resume].present?
      convert_attachment_to_resume_text(params[:resume])
      resume.attach(params[:resume])
    end
    self.classify_rank params
    rval = super params
    rval
  end

  def self.delete_all
    Submission.delete_all
    self.__elasticsearch__.delete_document
    Note.delete_all
    SavedCandidate.delete_all
    PhoneNumber.delete_all
    super
  end
  def self.pseudonym #used in admin
    "Candidate"
  end

  def inspect
    to_hash
  end

  def to_hash
    candidate_avatar_url = self&.avatar&.service_url if self&.avatar&.attached?
    {
      id: id,
      first_name: first_name,
      last_name: last_name,
      title: title,
      location: location,
      skills: skills,
      company_names: company_names,
      school: school,
      degree: degree,
      discipline: discipline,
      active: active,
      email_address: email_address,
      phone_number: phone_number,
      top_company: top_company,
      top_school: top_school,
      user_id: user_id,
      tags: tags,
      created_at: created_at,
      linkedin_profile_url: linkedin_profile_url,
      github_url: github_url,
      links: links,
      experiences: experience_years,
      image_url:  candidate_avatar_url
    }
  end

  def to_filtered_hash
    hash = to_hash
    hash[:email_address_filtered] = email_address_filtered
    hash[:phone_number_filtered] = phone_number_filtered
    hash
  end

  def init_note
    #hack to be able to enter a note using simpel form
  end

  EXPIRATION_PERIOD_MONTHS = 2
  def self.deactivate_outdated
    ppl_to_deactivate = Person.where('active_date_at < ?', EXPIRATION_PERIOD_MONTHS.months.ago )
    r_val = ppl_to_deactivate.size
    ppl_to_deactivate.each{ |p| p.update_attributes({active:false}) }
    r_val
  end
  def self.create params
    Person.create! params
  end
  #todo: replace this with `.encode("UTF-8", invalid: :replace, replace: "")`
  def remove_non_ascii_from_values params
    params.each do |k, v|
      params[k] = v.delete("^\u{0000}-\u{007F}") if v.is_a? String
    end
  end

  def ranking
    if top_20_percent?
      rand 81..99
    else
      rand 1..80
    end
  end

  def self.create! params
    person = Person.new
    person.avatar.attach(params[:avatar])
    person.notes << Note.new(
      user: params[:user],
      body: "Candidate profile created."
    )
    person.notes << Note.new(
      body: params[:init_note],
      user: params[:user]
    ) if params[:init_note].present?
    params[:active_date_at] = Date.today
    person.convert_attachment_to_resume_text(params[:resume]) if params[:resume].present?

    #todo: I think we're doing  3 writes to the same record here.  maybe consolidate
    t = person.transphorm_params params
    person.assign_attributes(t)
    person.save!
    person
  end

  def top_20_percent?
    self.tags&.include?  Person::TOP_2O_PERCENT_TAG
  end

  def transphorm_params params
    self.classify_rank params
    remove_non_ascii_from_values params
    only_attrs = params.slice *attributes.keys.map{ |e| e.to_sym}
    altered = {
      #todo: this is really lame that I have to rewrite all the parametrs that are not
      # attributes here.  There must be some way to get a list of fields including those
      # generated by associations.
      user: params[:user],
      #intake_batch: params[:intake_batch], the association between batch and person not yet supported
      resume: params[:resume],
      avatar: params[:avatar],
      original: params,
      skills: params[:skills]&.split(','),
      company_names: params[:company_names]&.split(' '),
      active: (true unless params[:active] === false)
    }
    altered.merge only_attrs
  end

  def classify_rank params
    params[:school] ||= education_experiences.pluck(:school_name)
    params[:company_names] ||= job_experiences.pluck(:company_name)
    params[:resume_text] = self.resume_text || ''
    self.tags = PersonHelper::CandidateRankClassifier.classify_rank(params)
    self.top_school = self.tags&.include? Person::TOP_SCHOOL_TAG
    self.top_company = self.tags&.include? Person::TOP_COMPANY_TAG
  end

  def convert_attachment_to_resume_text attachment
    if attachment&.tempfile.present?
      begin
        self.resume_text = (file_2_text(attachment.tempfile.path) || self.resume_text)
      rescue PDF::Reader::MalformedPDFError, Errno::ENOENT, Zip::Error => e
        Rails.logger.error "Could not parse file. #{e.message}"
        result =''
      end
      logger.info "resume_text obtained from attachemnt >#{self.resume_text[0..100]}...<" if self.resume_text.present?
    else
      logger.warn "no tempfile in the attachement param"
    end
  end

  IMPORT_HEADERS = "linkedin_profile_url,first_name,last_name,location,email_address,phone_number,title,company_names,school,degree,discipline,skills,matching_jobs,tags "

  attr_accessor :document_file_name

  paginates_per 25
  acts_as_followable
  acts_as_messageable
  attribute_method_prefix 'reset_'
  has_many :submissions, inverse_of: :person, dependent: :destroy
  # has_many :recruiter_updates, inverse_of: :person, dependent: :destroy
  # has_many :linkedin_profiles, inverse_of: :person, dependent: :destroy
  # has_many :company_positions, inverse_of: :person, dependent: :destroy
  # has_many :linkedin_profile_educations, inverse_of: :person, dependent: :destroy
  # has_many :linkedin_profile_positions, inverse_of: :person, dependent: :destroy
  # has_many :email_addresses, inverse_of: :person, dependent: :destroy
  # has_many :linkedin_profile_url_resources, inverse_of: :person, dependent: :destroy
  # has_many :phone_numbers, inverse_of: :person, dependent: :destroy
  # has_many :answers, inverse_of: :person, dependent: :destroy
  # has_many :comments, inverse_of: :person, dependent: :destroy
  # has_many :messages, inverse_of: :person, dependent: :destroy

  # has_many :questions, inverse_of: :person, dependent: :destroy
  # has_many :searches, inverse_of: :person, dependent: :destroy
  # has_many :call_sheets, inverse_of: :person, dependent: :destroy
  # has_many :placements, inverse_of: :person, dependent: :destroy
  # has_many :onsite_interviews, inverse_of: :person, dependent: :destroy
  # has_many :phone_interviews, inverse_of: :person, dependent: :destroy
  # has_many :submittals, inverse_of: :person, dependent: :destroy
  # has_many :calls, inverse_of: :person, dependent: :destroy
  # has_many :saved_candidates, inverse_of: :person, dependent: :destroy
  # #has_many :searched_candidates, inverse_of: :person, dependent: :destroy
  # has_many :flagged_candidates, inverse_of: :person, dependent: :destroy
  #has_many :uploads, inverse_of: :person, dependent: :destroy
  delegate :location_interest_usa, to: :user, allow_nil: true
  delegate :signuprole, to: :user, allow_nil: true
  delegate :city, to: :user, allow_nil: true
  delegate :state, to: :user, allow_nil: true
  # delegate :skills, to: :user, allow_nil: true
  delegate :linkedin_profile_positions, to: :user, allow_nil: true
  delegate :linkedin_profile_educations, to: :user, allow_nil: true


  #accepts_nested_attributes_for :uploads, allow_destroy: true
  # accepts_nested_attributes_for :recruiter_updates, allow_destroy: true
  # accepts_nested_attributes_for :email_addresses, allow_destroy: true
  # accepts_nested_attributes_for :phone_numbers, allow_destroy: true
  # accepts_nested_attributes_for :linkedin_profiles, allow_destroy: true


  accepts_nested_attributes_for :notes, allow_destroy: true

  #has_attached_file :attached_document, styles: {medium: "300x300>", thumb: "100x100>"}, default_url: "/attached_documents/:style/missing.png"
  #do_not_validate_attachment_file_type :attached_document



  # has_attached_file :avatar,
  #                   # In order to determine the styles of the image we want to save
  #                   # e.g. a small style copy of the image, plus a large style copy
  #                   # of the image, call the check_file_type method
  #                   styles: lambda { |a| a.instance.check_file_type },
  #                   processors: lambda {
  #                       |a| a.is_video? ? [:ffmpeg] : [:thumbnail] #check what ffmpeg
  #                   },
  #                   url: "/system/:class/:attachment/:id_partition/:style/:hash.:extension",
  #                   hash_secret: ENV.fetch('PAPERCLIP_HASH_SECRET'),
  #                   storage: :s3,
  #                   preserve_files: true,
  #                   s3_protocol: :https,
  #                   s3_permissions: :private,
  #                   s3_credentials: {
  #                       bucket: ENV.fetch('S3_BUCKET_NAME'),
  #                       access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
  #                       secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
  #                       s3_region: ENV.fetch('AWS_REGION')
  #                   }

  # do_not_validate_attachment_file_type :avatar
  #
  # has_attached_file :document,
  #                   styles: {medium: "300x300", thumb: "100x100"},
  #                   default_url: "/system/:class/:attachment/:id_partition/:hash.:extension",
  #                   url: "/system/:class/:attachment/:id_partition/:hash.:extension",
  #                   hash_secret: ENV.fetch('PAPERCLIP_HASH_SECRET'),
  #                   storage: :s3,
  #                   preserve_files: true,
  #                   s3_protocol: :https,
  #                   s3_permissions: :private,
  #                   s3_credentials: {
  #                       bucket: ENV.fetch('S3_BUCKET_NAME'),
  #                       access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
  #                       secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
  #                       s3_region: ENV.fetch('AWS_REGION')
  #                   }
  #
  # do_not_validate_attachment_file_type :document

  # Before applying the Imagemagick post processing to this record
  # check to see if we indeed wish to process the file. In the case
  # of audio files, we don't want to apply post processing
  # before_post_process :apply_post_processing?

  # Helper method that uses the =~ 'match operator' and legible regex method to see if
  # the current file_upload has a content_type
  # attribute that contains the string "image" / "video", or "audio"
  def is_image?
    self.document.content_type =~ %r(image) #what's =~ and what's %r
    # What is `=~`? A Ruby 'match operator' to match a string against a regular expression https://stackoverflow.com/questions/26938262/what-do-and-mean-in-ruby
    # What is `%r`? A Ruby expression https://stackoverflow.com/questions/12384704/the-ruby-r-expression
  end

  def is_video?
    self.document_content_type =~ %r(video)
  end

  def is_audio?
    self.document_content_type =~ /\Aaudio\/.*\Z/
  end

  def is_plain_text?
    self.document_file_name =~ %r{\.(txt)$}i
  end

  def is_excel?
    self.document_file_name =~ %r{\.(xls|xlt|xla|xlsx|xlsm|xltx|xltm|xlsb|xlam|csv|tsv)$}i
  end

  def is_word_document?
    self.document_file_name =~ %r{\.(docx|doc|dotx|docm|dotm)$}i
  end

  def is_powerpoint?
    self.document_file_name =~ %r{\.(pptx|ppt|potx|pot|ppsx|pps|pptm|potm|ppsm|ppam)$}i
  end

  def is_pdf?
    self.document_file_name =~ %r{\.(pdf)$}i
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


  # Method to be called in order to determine what styles we should
  # save of a file.
  def check_file_type
    if self.is_image?
      {
          :thumb => "200x200>", #hash rocket, mapping the label to the correct size based on type
          :medium => "500x500>"
      }
    elsif self.is_pdf?
      {
          :thumb => "200x200>", #hash rocket, mapping the label to the correct size based on type
          :medium => "500x500>"
      }
    elsif self.is_video?
      {
          :thumb => {
              :geometry => "200x200>",
              :format => 'jpg',
              :time => 0
          },
          :medium => {
              :geometry => "500x500>",
              :format => 'jpg',
              :time => 0
          }
      }
    elsif self.is_audio?
      {
          :audio => {
              :format => "mp3"
          }
      }
    else
      {}
    end
  end

  def self.avatar_url(email_id)
    person = Person.find_by(email_address: email_id)
    begin
      person&.avatar.&service_url if person&.avatar&.attached?
    rescue  NameError => e
      " "
    end 
  end


  #
  # multisearchable :against => :active
  #
  # pg_search_scope :search_by_keywords, :against => [:skills, :title, :degrees, :fields, :search_text, :keyword]
  # pg_search_scope :search_by_full_name, :against => [:name, :first_name, :last_name, :formatted_name]
  # pg_search_scope :search_by_locations, :against => [:location]
  # pg_search_scope :search_by_employers, :against => [:company_names]
  # pg_search_scope :search_by_titles, :against => [:title]
  # pg_search_scope :search_by_schools, :against => [:school_names]
  # pg_search_scope :search_by_degrees, :against => [:degrees]
  # pg_search_scope :search_by_disciplines, :against => [:fields]
  # pg_search_scope :search_by_emails, :associated_against => {
  #   :email_addresses => [:email]
  # }
  # pg_search_scope :search_by_phone_numbers, :associated_against => {
  #   :phone_numbers => [:value]
  # }
  # pg_search_scope :search_by_linkedin_urls, :associated_against => {
  #   :linkedin_profile => [:public_profile_url]
  # }
  #
  # scope :created_between, lambda { |start_date, end_date | where("created_at >= ? AND created_at <= ?", start_date, end_date )}

  def mailboxer_name
    self.name
  end

  def mailboxer_email(object)
    self.email_address
  end

  def self.dedupe
    # find all person records and group them on common keys
    grouped = all.group_by { |person| [person.linkedin_profile_url, person.email_address] }
    grouped.values.each do |duplicates|
      most_recent = duplicates.pop
      duplicates.each do |dupe|
        dupe.linkedin_profiles.destroy_all
        dupe.phone_numbers.destroy_all
        dupe.email_addresses.destroy_all
        dupe.destroy
      end
    end
  end

  def resume_url
    Rails.env.test? ? Rails.application.routes.url_helpers.url_for(resume) : resume.service_url
  end

  # Todo: store avatar url to cache
  def avatar_url
    avatar.service_url if avatar.attached?
  end

  def applied_all_jobs_last_30_days?
    !(applied_to_all_jobs.nil? || applied_to_all_jobs < DateTime.now - 30.days)
  end

  # Update avatar of passive candidates
  # download remote image and store to avatar
  def update_avatar(url)
    return if url.nil? && url.blank?
    begin
      uri = URI.parse(url)
      filename = File.basename(uri.path)
      downloaded_image = open(url)
      avatar.attach(io: downloaded_image, filename: filename)
    rescue OpenURI::HTTPError
      puts 'bad url , unable to update avatar....'
    end
  end


  private

  def build_address
    @addresses = Address
                     .select(
                         'id',
                         'categorytypeid',
                         'targetentityid',
                         'targetentityid_type',
                         'line1',
                         'line2',
                         'city',
                         'state',
                         'zipcode',
                         'location',
                         'isprimary',
                         'countryid'
                     )
  end

  def reset_attribute(attribute)
    send("#{attribute}=", 0)
  end

  def self.with_no_linkedin_profile_by(email_address)
    includes(:linkedin_profile).
        references(:linkedin_profile).
        where.not(linkedin_profile: {email_address_id: email_address.id})
  end

  def self.phone_number_available
    true unless self.linkedin_profile.phone_numbers.blank?
  end

  def self.linkedin_available
    true unless self.linkedin_profile.public_profile_url.blank?
  end

  def get_education_experiences
    education_experiences.pluck(:degree).reject{ |x| x.to_s.empty? }
  end

  def get_company_names
    job_experiences.pluck(:company_name).reject{ |x| x.to_s.empty? }
  end

end
