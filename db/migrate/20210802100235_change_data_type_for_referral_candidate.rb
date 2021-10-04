class ChangeDataTypeForReferralCandidate < ActiveRecord::Migration[5.2]
  def change
    remove_column :jobs, :referral_candidate
    add_column :jobs, :referral_candidate, :boolean, default: false
  end
end
