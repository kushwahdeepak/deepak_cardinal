class SubmittedCandidateInfo < ActiveRecord::Base
  self.primary_key = :id

  belongs_to :job
  belongs_to :submission

  include EsSubmittedCandidateInfo

  # searchable do
  #   integer :candidate_id
  #   text :search_text, boost: 5.0, :stored => true
  #   text :keyword, :stored => true
  #   text :skills, :stored => true
  #   text :location, :stored => true
  #   text :company_names, :stored => true
  #   text :title, :stored => true
  #   text :school, :stored => true
  #   text :first_name, :stored => true
  #   text :last_name, :stored => true
  #   text :degree, :stored => true
  #   text :discipline, :stored => true
  #   text :email_address, :stored => true
  #   boolean :top_school, :stored => true
  #   boolean :top_company, :stored => true
  #   boolean :active, :stored => true
  #   text :phone_number, :stored => true
  #   text :tags, :stored => true
  #   string :organization_id
  #   boolean :public, stored: true #some crap referenced from welcome page.  todo: get rid of this
  #   double :match_score, :stored => true
  #   integer :job_id, :stored => true
  #   text :candidate_stage
  # end

  def self.recreate_sql
    ActiveRecord::Base.connection.execute(
      <<-SQL.squish
  DROP VIEW IF EXISTS submitted_candidate_infos;

  CREATE OR REPLACE VIEW submitted_candidate_infos AS
    SELECT people.first_name, people.last_name, people.formatted_name, people.linkedin_profile_url, people.phone_number,
           people.search_text, people.keyword, people.location, people.employer, people.title, people.school, people.degree,
           people.discipline, people.name, people.min_time_in_job, people.max_time_in_job, people.min_career_length,
           people.max_career_length, people.min_activity_date, people.max_activity_date, people.email_available, 
           people.linkedin_available, people.phone_number_available, people.github_available, people.top_company_status,
           people.linkedin_profile_id_id, people.created_at, people.updated_at, people.avatar_url, people.linkedin_profile,
           people.company_position, people.email_address, people.linkedin_field_of_study, people.linkedin_industry,
           people.linkedin_profile_education, people.linkedin_profile_position, people.linkedin_profile_publication, 
           people.linkedin_profile_recommendation, people.linkedin_profile_url_resource, people.linkedin_school, people.active,
           people.user_id, people.note_id, people.flag, people.crelate_id, people.created_by_id, people.modified_on,
           people.updated_by_id, people.created_on, people.salary, people.salutation, people.icon_attachment_id,
           people.primary_document_attachment_id, people.nickname, people.account_id, people.contact_number, people.twitter_name,
           people.contact_source_id, people.middle_name, people.suffix_id, people.ethnicity_id, people.gender_id,
           people.preferred_contact_method_type_id, people.last_activity_regarding_id, people.last_activity_regarding_id_type,
           people.last_activity_date, people.spoken_to, people.contact_status_id, people.contact_merge_id, people.approve_for_job_id,
           people.salary_details, people.record_type, people.description, people.created_on_system, people.contact_num,
           people.skills, people.school_names, people.degrees, people.fields, people.company_names, people.createdbyid,
           people.modifiedon, people.updatedbyid, people.work_authorization_status, people.document_file_name, people.document_content_type,
           people.document_file_size, people.document_updated_at, people.top_one_percent_status, people.top_five_percent_status,
           people.top_ten_percent_status, people.status, people.recruiter_update_id, people.recently_added, people.active_date_at,
           people.active_set_by_user_id, people.inbound_user_id, people.phone_number_id, people.person_id, people.remote_interest,
           people.position_interest, people.experience_years, people.supervising_num, people.salary_expectations,
           people.job_search_stage, people.position_desc, people.visa_status, people.avatar_file_name, people.avatar_content_type,
           people.avatar_file_size, people.avatar_updated_at, people.latest_pinned_note, people.sms_last_from_user_id,
           people.github_url, people.stack_overflow_url, people.personal_site, people.personal_site_available, 
           people.stack_overflow_url_available, people.public_profile_url, people.api_standard_profile_request, people.industry,
           people.current_share, people.num_connections, people.num_connections_capped, people.summary, people.specialties,
           people.positions, people.picture_url, people.site_standard_profile_request, people.lever_candidate_id, 
           people.company_position_id, people.linkedin_profile_id, people.email_address_id, people.linkedin_field_of_study_id,
           people.linkedin_industry_id, people.linkedin_profile_education_id, people.linkedin_profile_position_id, 
           people.linkedin_profile_publication_id, people.linkedin_profile_recommendation_id, people.linkedin_profile_url_resource_id,
           people.linkedin_school_id, people.education_level, people.public, people.attached_document_file_name,
           people.attached_document_content_type, people.attached_document_file_size, people.attached_document_updated_at,
           people.message_date, people.top_company, people.top_school, people.tags, people.original,
           people.resume_text, people.applied_to_all_jobs, people.organization_id, people.links,
           CONCAT(people.id::text, match_scores.id::text) as id, people.id as candidate_id, jobs.id as job_id, 
           submissions.id as submission_id, COALESCE(match_scores.score, 0.0) as match_score,
           stage_transitions.stage as candidate_stage
    FROM people
    LEFT JOIN match_scores ON (match_scores.person_id = people.id)
    LEFT JOIN submissions ON (submissions.person_id = people.id AND submissions.job_id = match_scores.job_id)
    LEFT JOIN stage_transitions ON (stage_transitions.submission_id = submissions.id) AND stage_transitions.id = 
    (
       SELECT MAX(stage_transitions.id)
       FROM stage_transitions
       WHERE stage_transitions.submission_id = submissions.id
    )
    LEFT JOIN jobs ON (jobs.id = match_scores.job_id)
      SQL
    )
  end

  def to_hash
    {
      id: candidate_id,
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
      score: match_score
    }
  end
end
