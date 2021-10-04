class CreateEmailSequences < ActiveRecord::Migration[5.2]
  def up
    create_table :email_sequences, id: :uuid do |t|
      t.string :subject
      t.text :email_body
      t.datetime :sent_at
      t.references :job, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :email_sequences
  end
end
