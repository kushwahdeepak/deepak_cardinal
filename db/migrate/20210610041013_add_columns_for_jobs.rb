class AddColumnsForJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :company_name, :string
    add_column :jobs, :location, :string
    add_column :jobs, :referral_candidate, :string
    add_column :jobs, :referral_amount, :string
    add_column :jobs, :email_campaign_subject, :string
    add_column :jobs, :email_campaign_desc, :string
    add_column :jobs, :sms_campaign_desc, :string
    add_column :jobs, :location_preference, :string
    add_column :jobs, :prefered_titles, :string
    add_column :jobs, :prefered_industries, :string
  end
end
