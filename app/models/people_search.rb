

class PeopleSearch < ApplicationRecord
  self.table_name = 'searches'

  belongs_to :user, optional: true
  belongs_to :person, optional: true
  belongs_to :job, optional: true
  MATCH_SCORE_NAME = "person_match_score"
  def attributes
    attrs = super
    attrs.delete_if { |k, v| v.nil? || v === '' }
  end

  def query_search_engine_get_people(page = 1, excluded_people = nil, per_page: nil, included_people: nil, job_id: nil, email_type: nil, organization_id: nil, stage: nil, match_score_value: 25) #todo: handle exception thrown when solr is unavailable
    Rails.logger.tagged("Initiating search") { logger.debug(attributes.inspect) }
    attr = {}
    attr[:organization_id] = organization_id
    attr[:title] = titles if titles.present?
    attr[:skills] = skills if skills.present?
    attr[:school] = schools if schools.present?
    attr[:company_names] = company_names if company_names.present?
    attr[:experience_years] = experience_years if experience_years.present?
    attr[:keyword] = keyword if keyword.present?
    attr[:tags] = tags if tags.present?
    attr[:top_company] = true if top_company.present?
    attr[:top_school] = true if top_school.present?
    attr[:email_address] = emails.present? ? emails : ''
    attr[:email_type] = email_type if email_type.present? && (email_type == "Personal" || email_type == "Company")
    attr[:phone_number] = true if phone_number_available.present?
    attr[:active] = active if active
    attr[:location] = locations if locations.present?
    attr[:job_id] = job_id if job_id.present?
    attr[:names] = names if names.present?
    attr[:degree] = degrees if degrees.present?
    attr[:discipline] = disciplines if disciplines.present?
    # without(:email_address, "%gmail.com%") if email_type.present?
    if attr.present? && !job_id.present?
      attr[:id] = included_people if included_people.present?
      Person.search_candidate_with_filters(attr).records.order(created_at: :desc).paginate(page: page, per_page: per_page || 25).includes(avatar_attachment: :blob)
    end
  end

  def search_people_for_campaign(campaign_owner_id:, page: nil, job_id: nil, period_key: nil, per_page: nil, email_type: nil, with_score: true, stage: nil)
    people_to_exclude = get_excluded_people(campaign_owner_id, job_id, period_key)
    organization_id = User.find(campaign_owner_id)&.organization&.id
    match_score_value = SystemConfiguration.find_by(name: MATCH_SCORE_NAME)&.value
    if with_score.present?
      query_search_engine_get_people(page, people_to_exclude, per_page: per_page, job_id: job_id, email_type: email_type, organization_id: organization_id, match_score_value: match_score_value, stage: stage)
    else
      query_search_engine_get_people(page, people_to_exclude, per_page: per_page, job_id: job_id, email_type: email_type, organization_id: organization_id)
    end
  end

  def search_filter_for_ats(candidates, email_type)
    persons = []
    persons +=  candidates.where("CONCAT(lower(first_name), ' ',lower(last_name)) LIKE ? OR ',' || lower(skills) || ',' LIKE ?", "%#{keyword.downcase}%", "%,#{keyword.downcase},%" ) if keyword.present?
    
    locations.split(',').each do |location|
      persons +=  candidates.where("lower(location) ~* ?", location.downcase)
    end if locations.present?
    
    names.split(',').each do |name|
      persons +=  candidates.where("lower(first_name) LIKE ? OR lower(last_name) LIKE ?", "%#{name.downcase}%", "%#{name.downcase}%")    
    end if names.present?

    titles.split(',').each do |title|
      persons += candidates.where("lower(title) LIKE ?", "%#{title.downcase}%")
    end if titles.present?

    skills.split(',').each do |skill|
      persons += candidates.where(" ',' || lower(skills) || ',' LIKE ?", "%,#{skill.downcase},%")
    end if skills.present?

    persons += candidates.where("active = ? ", true) if active.present?

    persons += candidates.where("top_school = ? ", true) if top_school.present?

    persons += candidates.where("top_company = ? ", true) if top_company.present?

    persons += candidates.where("phone_number IS NOT NULL") if phone_number_available.present?
    
    if email_type == "Personal" 
      persons += candidates.where("lower(email_address) LIKE ?", "%gmail.com")
    elsif email_type == "Company"
      persons += candidates.where("lower(email_address) NOT LIKE ?", "%gmail.com")
    end 

    persons += candidates.where("lower(email_address) LIKE ?", "%#{emails.downcase}%") if emails.present?

    company_names.split(',').each do |company_name|
      persons += candidates.where("company_names ~* ? ", company_name.downcase)
    end if company_names.present?
    
    schools.split(',').each do |school|
      persons += candidates.where("lower(school) LIKE ?", "%#{school.downcase}%")
    end if schools.present?

    if keyword.present? || locations.present? || top_school.present? || company_names.present? || schools.present? || emails.present? || top_company.present? || active.present? || skills.present? || titles.present? || names.present? || phone_number_available.present? || email_type.present? || emails.present?
      return persons.uniq
    else 
      return candidates
    end
  end

  def search_for_leads(current_user, page, period_key, count, job_id, email_type, with_score)
    people = search_people_for_campaign(
      campaign_owner_id: current_user.id, page: page,
      job_id: job_id, period_key: period_key,
      per_page: count, email_type: email_type, with_score: with_score
    )
    search_peoples = people.map(&:to_hash)
    total_person = Person.all.count
    set_last_contacted_and_match_scores(people, search_peoples, job_id,current_user )
    {
      page: page || 1,
      total: people.total_count,
      total_pages: people.total_pages,
      total_persons: total_person,
      people: search_peoples
    }
  end

  def get_excluded_people(campaign_owner_id, job_id, period_key)
    blacklisted_people_ids = Blacklist.where(user_id: campaign_owner_id).pluck(:person_id)
    # people_working_for_client_companies_ids = people_working_for_client_companies.pluck(:id)
    contacted_people_ids = get_contacted_people_ids(campaign_owner_id, period_key)
    (blacklisted_people_ids + contacted_people_ids).uniq # + people_working_for_client_companies_ids
  end

  private

  def get_degree
    degree_list = degrees&.split(',')
    if degree_list&.include?(Person::DEGREE_BACHELORS)
      Person::DEGREE_BACHELORS + ' OR '+ Person::DEGREE_MASTERS+ ' OR '+ Person::DEGREE_DOCTORATE
    elsif degree_list&.include?(Person::DEGREE_MASTERS)
      Person::DEGREE_MASTERS + ' OR '+ Person::DEGREE_DOCTORATE
    elsif degree_list&.include?(Person::DEGREE_DOCTORATE)
      Person::DEGREE_DOCTORATE
    else
      nil
    end
  end

  # def people_working_for_client_companies
  #   Sunspot.search(Person) do
  #     any { client_companies.each { |client_company| fulltext(client_company, fields: :company_names) } }
  #     paginate page: 1, per_page: Person.count
  #   end.results
  # end

  def get_contacted_people_ids(campaign_owner_id, period_key)
    campaign_owner = User.find(campaign_owner_id)
    organization_id = campaign_owner.organization_id
    if organization_id.present? && period_key.present?
      CampaignRecipient.find_contacted_recipients(organization_id, period_key).pluck(:recipient_id)
    else
      []
    end
  end

  # def client_companies
  #   %w(BlackLine Boeing)
  # end

  def set_last_contacted_and_match_scores(peoples, search_peoples, job_id, current_user)
    # organization_ids = User.where(id: peoples.pluck(:user_id)).pluck(&:organization_id)
    organization_id = current_user&.organization&.id
    campaign_recipients = CampaignRecipient.where(organization_id: organization_id)
    submission_details = Submission.where(person_id: peoples.pluck(:id))
    search_peoples.each do |people|
      last_contacted_recipient = campaign_recipients.where(recipient_id: people[:id]).order(:contact_recipient_at).first
      job_ids = submission_details.where(person_id: people[:id])
      people[:applications] = Job.where(id: job_ids.pluck(:job_id), organization_id: organization_id)&.map(&:to_hash)
      people[:applications].each do |application|
        submission = Submission.find_by(person_id: people[:id], job_id: application[:id])
        application[:stage] = StageTransition.where(submission_id: submission)&.last if submission.present?
      end
      people[:last_contacted_content] = customize_content(people, last_contacted_recipient&.campaign&.content)&.gsub(%r{</?[^>]+?>},'')
      people[:last_contacted_time] = last_contacted_recipient&.contact_recipient_at
      people[:last_login] = User.find_by(email: people[:email_address])&.last_sign_in_at if people[:email_address].present?
    end
  end

  def customize_content(people, content)
    first_name = people[:first_name].present? ? people[:first_name]: ''
    last_name = people[:last_name].present? ?people[:last_name] : ''
    campaign_content = content&.gsub('{{first_name}}', first_name)&.gsub('{{last_name}}', last_name)
  end
end
