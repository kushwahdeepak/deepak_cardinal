class AddEmailVerificationColumbnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :send_email_request, :boolean, default: false
    add_column :users, :user_verification_status, :string
  end
end
