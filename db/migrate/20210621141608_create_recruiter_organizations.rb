class CreateRecruiterOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :recruiter_organizations do |t|
      t.references :organization,type: :uuid, index: true
      t.references :user, index: true
      t.string :status
    end
  end
end
