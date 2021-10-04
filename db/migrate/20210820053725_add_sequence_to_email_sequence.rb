class AddSequenceToEmailSequence < ActiveRecord::Migration[5.2]
  def up
    add_column :email_sequences, :sequence, :string
  end

  def down
    remove_column :email_sequences, :sequence
  end
end
