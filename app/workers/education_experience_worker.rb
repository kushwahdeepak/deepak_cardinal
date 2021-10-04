class EducationExperienceWorker
  include Sidekiq::Worker

  def perform
    EducationExperience.where.not('degree IS null OR degree = ?', "").each do |ee|
      ee.update_degree
    end
  end
end
