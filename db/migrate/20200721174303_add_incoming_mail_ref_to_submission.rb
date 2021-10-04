class AddIncomingMailRefToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_reference :submissions, :incoming_mail, foreign_key: true
  end
end
