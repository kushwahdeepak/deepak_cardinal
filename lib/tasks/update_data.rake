namespace :update_data do
  desc "Update new company data in our database"
  task :company => :environment do
    CompanyProfileWorker.perform_async
  end

  desc "Update degree in our database"
  task :education_exp => :environment do
    EducationExperienceWorker.perform_async
  end
end