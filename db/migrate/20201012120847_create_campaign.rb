class CreateCampaign < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.datetime :start_date, null: false
      t.integer :duration_days, null: false
      t.string :source_address, null: false
      t.string :subject, null: false
      t.text :content, null: false
      
      t.integer :job_id, null: false
      t.integer :user_id, null: false
    end
  end
end
