
class JobSearch < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :job, optional: true
  

  def query_search_engine_get_jobs(page: 1, per_page: 25, own_jobs: false, closed_jobs: false)
    attr = {}
    attr[:creator_id] = user_id if own_jobs == true
    attr[:name] = title if title.present?
    attr[:skills] = skills if skills.present?
    attr[:school_names] = school_names if school_names.present?
    attr[:company_names] = company_names if company_names.present?
    attr[:experience_years] = experience_years if experience_years.present?
    attr[:keyword] = keyword if keyword.present?
    attr[:organization_id] = user.organization_id if user.organization_id.present? && own_jobs == false
    attr[:job_keyword] = job_keyword if job_keyword.present?
    attr[:active] = closed_jobs == true ? false : true
    
    if locations.present?
      location = Location.find_by(id: locations)

      attr[:locations] = "#{location.country}, #{location.state}, #{location.city}" if location.present?
    end
    
    jobs = user.jobs.where(active: attr[:active])
    if user.role == 'recruiter' || attr[:creator_id].present?
      if attr[:creator_id] || (attr[:organization_id] && attr[:active].blank?)
        jobs = jobs.where(creator_id: user_id)
      end
    end

    if attr[:job_keyword].present?
      jobs = jobs.search_job_with_keyword(job_keyword)
    end

    jobs.order(created_at: :desc).paginate(page: page.to_i, per_page: per_page).includes(logo_attachment: :blob)
  end

  def job_location
    location = JobsLocation.where(location_id: self.locations).pluck(:job_id)
    jobs = Job.where(id: location)
  end

  def self.person_job_search_attributes
    {
      school_names: :school,
      company_names: :company_names,
      skills: :skills,
      experience_years: :experience_years,
      locations: :location,
      user_id: :user_id
    }
  end
end
