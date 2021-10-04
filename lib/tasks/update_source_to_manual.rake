namespace :update do
  desc 'update all system users source column to manual'
  task system_user_source_col_to_manual: :environment do
    Person.where(user_id: User.ids).update_all(source: Person::SOURCE[:system])
  end

  desc 'update passive candidate source column to incoming_mail'
  task candidates_source_col_to_incoming_mail: :environment do
    puts "> Starting"
    puts "> fetching candidate_email from incoming mails table"
    emails = IncomingMail.pluck(:candidate_email).compact!
    puts "Found incoming mails: #{emails.count}"
    puts "updating all passive candidates source to incoming_mail"
    Person.where(email_address: emails).update_all(source: Person::SOURCE[:incoming_mail])
    puts "completed..."
  end
end
