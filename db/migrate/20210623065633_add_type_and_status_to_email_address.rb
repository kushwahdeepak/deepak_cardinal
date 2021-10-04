class AddTypeAndStatusToEmailAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :email_addresses, :email_type, :string
    add_column :email_addresses, :status, :string
  end
end
