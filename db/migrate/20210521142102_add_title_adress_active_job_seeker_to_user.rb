class AddTitleAdressActiveJobSeekerToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :title, :string
    add_column :users, :active_job_seeker, :string
    add_column :users, :address, :string
  end
end
