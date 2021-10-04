class AddMailStatusToCampaignRecipients < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE mail_status AS ENUM ('pending', 'sent', 'failed');
    SQL
    add_column :campaign_recipients, :status, :mail_status, default: :pending
  end

  def down
    remove_column :campaign_recipients, :status
    execute <<-SQL
      DROP TYPE mail_status;
    SQL
  end
end
