class CompanyProfileWorker
  include Sidekiq::Worker

  def perform
    company_profiles = []
    company_names = JobExperience.pluck(:company_name).uniq
    company_names.each do |company_name|
      next if company_name.blank?
      company_prof = CompanyProfile.find_or_initialize_by(company_name: company_name)
      company_profiles << company_prof if company_prof.id.nil?
    end

    CompanyProfile.import company_profiles, batch_size: 1000
  end
end
