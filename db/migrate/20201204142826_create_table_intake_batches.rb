class CreateTableIntakeBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :intake_batches do |t|
      t.string "model_klass"
      t.integer "ok_count", default: 0, null: false
      t.integer "err_count", default: 0, null: false
      t.string "code_version"
      t.string "status", default: "not done", null: false
      t.bigint "user_id", null: false
      t.text "log"
      t.index ["user_id"], name: "index_intake_batches_on_user_id"
    end
  end
end
