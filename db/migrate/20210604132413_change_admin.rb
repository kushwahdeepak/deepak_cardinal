class ChangeAdmin < ActiveRecord::Migration[5.2]
  def up
    add_reference :admins, :user
    remove_column :admins, :encrypted_password
    remove_column :admins, :reset_password_token
    remove_column :admins, :reset_password_sent_at
    remove_column :admins, :remember_created_at
    remove_column :admins, :sign_in_count
    remove_column :admins, :current_sign_in_at
    remove_column :admins, :last_sign_in_at
    remove_column :admins, :current_sign_in_ip
    remove_column :admins, :last_sign_in_ip
  end

  def down
    remove_reference :admins, :user
    add_column :admins, :encrypted_password, :string
    add_column :admins, :reset_password_token, :string
    add_column :admins, :reset_password_sent_at, :datetime
    add_column :admins, :remember_created_at, :datetime
    add_column :admins, :sign_in_count, :integer
    add_column :admins, :current_sign_in_at, :datetime
    add_column :admins, :last_sign_in_at, :datetime
    add_column :admins, :current_sign_in_ip, :inet
    add_column :admins, :last_sign_in_ip, :inet
  end
end
