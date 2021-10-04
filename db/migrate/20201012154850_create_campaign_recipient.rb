class CreateCampaignRecipient < ActiveRecord::Migration[5.2]
  def change
    create_table :campaign_recipients do |t|
      t.datetime :contact_recipient_at
      t.integer :recipient_id, null: false
      t.integer :campaign_id, null: false
    end
  end
end
