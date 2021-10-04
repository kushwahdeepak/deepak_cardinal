class AddTypeToSubmission < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :submission_type, :string, default: nil
  end
end
