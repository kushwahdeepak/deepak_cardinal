class AddSourceAndCandidateNameToIncomingMail < ActiveRecord::Migration[5.2]
  def change
    add_column :incoming_mails, :source, :string
    add_column :incoming_mails, :candidate_name, :string, default: ''
  end
end
