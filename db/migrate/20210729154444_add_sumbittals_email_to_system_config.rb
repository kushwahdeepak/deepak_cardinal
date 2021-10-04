class AddSumbittalsEmailToSystemConfig < ActiveRecord::Migration[5.2]
  def up
    add_column :system_configurations, :subject, :string
    SystemConfiguration.create(name: 'submittals_email', value: 0, subject: 'submittals@cardinaltalent.ai' )
  end

  def down
    SystemConfiguration.find_by(name: 'submittals_email')&.destroy
  end  
end