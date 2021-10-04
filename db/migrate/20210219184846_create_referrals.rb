class CreateReferrals < ActiveRecord::Migration[5.2]
  def change
    create_table :referrals, id: :uuid do |t|
      t.integer :inviter_id, null: false
      t.integer :job_id, null: false
      t.string :invitee_name
      t.string :invitee_email
      t.string :invitee_phone
      t.text :message
      t.datetime :invitation_date
      t.datetime :email_send_date
      t.string :invitee_code
      t.datetime :signup_date
      t.datetime :job_applied_date

      t.timestamps
    end

    add_index :referrals, [:invitee_code, :invitee_email], name: "index_by_referral"
  end
end
