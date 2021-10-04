require 'csv'

namespace :utilities do
  desc "Upload candidate data from csv file"

  task upload_candidates_csv: :environment do
    puts  "starting...."
    file_path = Rails.root.to_s + '/csv/salesQl_candidates.csv'
    salesQl = CSV.read(file_path, headers: true) rescue []

    valid_person = 0
    invalid_person = 0
    education_experience = []
    user_emails = []
    phone_numbers = []
    all_emails = []
    valid_job_exp = []
    invalid_job_exp = []

    salesQl.each do |row|
      next unless row['email1'].present? || row['email2'].present? || row['email3'].present?

      person_links = []
      person_links << row['person_angellist_url']  if row['person_angellist_url'].present?
      person_links << row['person_crunchbase_url']  if row['person_crunchbase_url'].present?
      person_links << row['person_twitter_url']  if row['person_twitter_url'].present?
      person_links << row['person_facebook_url']  if row['person_facebook_url'].present?
      person_links << row['company_linkedin_url']  if row['company_linkedin_url'].present?

      person = Person.new()
      person.attributes = {
        first_name: row['first_name'],
        last_name: row['last_name'],
        email_address: row['email1'] || row['email2'] || row['email3'],
        title: row['headline'] || '',
        skills: row['person_skills'] || '',
        industry: row['person_industry'] || '',
        linkedin_profile_url: row['person_linkedin_url'] || '',
        links: person_links,
        active: true,
        source: Person::SOURCE[:salesql_email]
      }

      # download remote image and store into person avatar
      if row['person_image_url'].present?
        person.update_avatar(row['person_image_url']) rescue nil
      end

      begin
        if person.save!
          valid_person = valid_person + 1
  
          # Job Experience
          valid_job_exp << person.job_experiences.build(id: SecureRandom.uuid, title: row['current_position'] ,  description: ' ', company_name: row['company_name'], location: row['person_city'], present: true) if row['current_position'].present?
          valid_job_exp << person.job_experiences.build(id: SecureRandom.uuid, title: row['current_position_2'] ,   description: ' ', company_name: row['current_company_2'], location: row['company_city'], present: false) if row['current_position_2'].present? 
          valid_job_exp << person.job_experiences.build(id: SecureRandom.uuid, title: row['previous_position_2'] ,  description: ' ', company_name: row['previous_company_2'], location: row['company_city'], present: false) if row['current_position_2'].present?
          valid_job_exp << person.job_experiences.build(id: SecureRandom.uuid, title: row['previous_position_3'] , description:  ' ', company_name: row['previous_company_3'], location: row['company_city'], present: false) if row['previous_position_3'].present?
  
          # Email Address
          user_emails << person.user_emails.build(email: row['email1'], email_type: row['email1_type'], status: row['email1_status']) if row['email1'].present?
          user_emails << person.user_emails.build(email: row['email2'], email_type: row['email2_type'], status: row['email2_status']) if row['email2'].present?
          user_emails << person.user_emails.build(email: row['email3'], email_type: row['email3_type'], status: row['email3_status']) if row['email3'].present?
          user_emails << person.user_emails.build(email: row['email4'], email_type: row['email4_type'], status: row['email4_status']) if row['email4'].present?
    
          # Phone Number
          phone_numbers << person.phone_numbers.build(value: row['phone1'], phone_type: row['phone1_type']) if row['phone1'].present?
          phone_numbers << person.phone_numbers.build(value: row['phone2'], phone_type: row['phone2_type']) if row['phone2'].present?
          phone_numbers << person.phone_numbers.build(value: row['phone3'], phone_type: row['phone3_type']) if row['phon3'].present?
          phone_numbers << person.phone_numbers.build(value: row['phone4'], phone_type: row['phone4_type']) if row['phone4'].present?
    
          # Education Expereince
          user_education = row['education_experience'].split(',') if row['education_experience'].present?
          if user_education.present?
            user_education.each do |school|
              education_experience << person.education_experiences.build(
                school_name: school,
              )
            end
          end
  
        end
        invalid_person = invalid_person + 1 unless person.valid?
      rescue => e
        invalid_person = invalid_person + 1
        Rails.logger.debug '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
        Rails.logger.debug "record with email #{person.email_address} failed due: #{e}"
        Rails.logger.debug '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
        Rails.logger.debug "Failed: #{person}"
      end
    end

    # Bluk import using active record import gem
    PhoneNumber.import phone_numbers, validate: false
    EmailAddress.import user_emails, validate: false
    JobExperience.import valid_job_exp, validate: false
    EducationExperience.import education_experience, validate: false

    puts "======================STATS===================="
    puts "valid person records: #{valid_person}"
    puts "invalid records: #{invalid_person}"
    puts "user_emails: #{user_emails.count}"
    puts "phone_numbers: #{phone_numbers.count}"
    puts "job experiences: #{valid_job_exp.count}"

  end

  desc 'Clear test data'

  task clear_test_data: :environment do
    EmailAddress.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).delete_all
    PhoneNumber.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).delete_all
    JobExperience.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).delete_all
    EducationExperience.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).delete_all
    Person.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).delete_all
  end
end

# records created on a day
# Person.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).delete_all
# EmailAddress.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).delete_all
# PhoneNumber.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).delete_all
# JobExperience.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).delete_all