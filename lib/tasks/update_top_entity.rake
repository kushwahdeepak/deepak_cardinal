namespace :update_top_entity do
  desc "Update top company and top school in our database"
  task :person => :environment do
    TopEntityWorker.perform_async
  end
end