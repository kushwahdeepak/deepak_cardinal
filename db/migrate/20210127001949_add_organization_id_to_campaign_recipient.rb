class AddOrganizationIdToCampaignRecipient < ActiveRecord::Migration[5.2]
  def change
     add_column :campaign_recipients, :organization_id, :uuid
     add_index :campaign_recipients, :organization_id
  end
end
