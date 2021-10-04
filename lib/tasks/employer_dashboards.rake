namespace :employer_dashboards do
  
  desc "Create employer dashboard records for all jobs"
  task create_dashboards: :environment do 
    Job.all.each do |job|
      UpdateEmployerDashboardService.new(job).call
    end
  end

end