class AddExpiryDateToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :expiry_date, :datetime
    jobs = Job.where(expiry_date: nil)
    jobs.each do |job|
      job.update(expiry_date: job&.created_at + 90.days)
    end
  end
end
