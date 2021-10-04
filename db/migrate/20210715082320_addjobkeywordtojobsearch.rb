class Addjobkeywordtojobsearch < ActiveRecord::Migration[5.2]
  def change
    add_column :job_searches, :job_keyword, :string
  end
end
