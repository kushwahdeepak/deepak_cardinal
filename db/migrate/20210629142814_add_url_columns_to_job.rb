class AddUrlColumnsToJob < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :linkedin_url, :string
    add_column :jobs, :indeed_url, :string
    add_column :jobs, :campaign_approved, :boolean, default: false
    add_column :jobs, :sync_job, :boolean, default: false
  end
end
