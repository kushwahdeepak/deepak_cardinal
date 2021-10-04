class AddEmailConfirmColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :users, :email_confirmed
      add_column :users, :email_confirmed, :boolean, :default => false
    end

    unless column_exists? :users, :confirm_token
      add_column :users, :confirm_token, :string
    end
  end
end