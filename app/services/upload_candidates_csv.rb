require 'open-uri'

class UploadCandidatesCsv

  def initialize(file_paths = [])
    @file_paths = file_paths
  end

  def file_import
    if @file_paths.present?
      @file_paths.each do |file_path|
        url = URI.parse(file_path)
        file = URI.open(url)

        salesQl = CSV.read(file, headers: true) rescue []

        valid_person = 0
        invalid_person = 0
        @education_experience = []
        @user_emails = []
        @phone_numbers = []
        # all_emails = []
        @valid_job_exp = []
        # invalid_job_exp = []

        salesQl.each do |row|
          email_address = row['email1'] || row['email2'] || row['email3']
          
          Rails.logger.debug row

          next if email_address.blank? || email_address.length <= 0

          person_links = []
          person_links << row['person_angellist_url']  if row['person_angellist_url'].present?
          person_links << row['person_crunchbase_url']  if row['person_crunchbase_url'].present?
          person_links << row['person_twitter_url']  if row['person_twitter_url'].present?
          person_links << row['person_facebook_url']  if row['person_facebook_url'].present?
          person_links << row['company_linkedin_url']  if row['company_linkedin_url'].present?

          attr = {
            first_name: row['first_name'],
            last_name: row['last_name'],
            email_address: email_address,
            title: row['headline'] || '',
            skills: row['person_skills'] || '',
            industry: row['person_industry'] || '',
            linkedin_profile_url: row['person_linkedin_url'] || '',
            links: person_links,
            active: false,
            source: Person::SOURCE[:salesql_email]
          }

          puts attr
          @person = Person.find_by(email_address: email_address)

          if @person.blank?
            @person = Person.new()
            @person.attributes = attr

            # download remote image and store into person avatar
            if row['person_image_url'].present?
              @person.update_avatar(row['person_image_url']) rescue nil
            end

            begin
              if @person.save!
                valid_person = valid_person + 1
              end

              invalid_person = invalid_person + 1 unless @person.valid?
            rescue => e
              invalid_person = invalid_person + 1
              Rails.logger.debug '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
              Rails.logger.debug "record with email #{@person.email_address} failed due: #{e}"
              Rails.logger.debug '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
              Rails.logger.debug "Failed: #{@person}"
            end

          else
            @person.attributes = attr
            @person.save
          end

          if @person.present? && @person.id.present?
            add_person_additional_data(row)

            # Bluk import using active record import gem
            # PhoneNumber.import @phone_numbers, on_duplicate_key_update: {constraint_name: :for_upsert, columns: [:updated_at]}
            # EmailAddress.import @user_emails, on_duplicate_key_update: {constraint_name: :for_email_upsert, columns: [:updated_at]}
            # JobExperience.import @valid_job_exp, on_duplicate_key_update: {constraint_name: :for_job_exp_upsert, columns: [:updated_at]}
            # EducationExperience.import @education_experience, on_duplicate_key_update: {constraint_name: :for_edu_upsert, columns: [:updated_at]}
            # EducationExperience.import @education_experience, on_duplicate_key_update: {conflict_target: [:school_name, :person_id], index_name: :for_edu_upsert, columns: [:updated_at, :from, :to]}


            puts "======================STATS===================="
            puts "valid person records: #{valid_person}"
            puts "invalid records: #{invalid_person}"
            puts "user_emails: #{@user_emails.count}"
            puts "phone_numbers: #{@phone_numbers.count}"
            puts "job experiences: #{@valid_job_exp.count}"
          end
        end
      end
    end
  end

  def add_person_additional_data(row)
    # Job Experience
    construct_job_experiences(row)
    # Email Address
    construct_email_addresses(row)
    # Phone Number
    construct_phone_numbers(row)
    # Education Expereince
    construct_education_experiences(row)
  end

  def construct_job_experiences(row)
    create_or_update_job_experiences(row['current_position'], row['company_name'], row['person_city'], true) if row['current_position'].present?
    create_or_update_job_experiences(row['current_position_2'], row['current_company_2'], row['company_city'], false) if row['current_position_2'].present?
    create_or_update_job_experiences(row['previous_position_2'], row['previous_company_2'], row['company_city'], false) if row['previous_position_2'].present?
    create_or_update_job_experiences(row['previous_position_3'], row['previous_company_3'], row['company_city'], false) if row['previous_position_3'].present?

    # JobExperience.find_or_create_by(title: row['current_position'],  description: ' ', company_name: row['company_name'], location: row['person_city'], present: true, person_id: @person.id) if row['current_position'].present?    
    # JobExperience.find_or_create_by(title: row['current_position_2'],   description: ' ', company_name: row['current_company_2'], location: row['company_city'], present: false, person_id: @person.id) if row['current_position_2'].present?
    # JobExperience.find_or_create_by(title: row['previous_position_2'],  description: ' ', company_name: row['previous_company_2'], location: row['company_city'], present: false, person_id: @person.id) if row['current_position_2'].present?
    # JobExperience.find_or_create_by(title: row['previous_position_3'], description:  ' ', company_name: row['previous_company_3'], location: row['company_city'], present: false, person_id: @person.id) if row['previous_position_3'].present?
  end

  def construct_email_addresses(row)
    create_or_update_email_addresses(row['email1'], row['email1_type'], row['email1_status']) if row['email1'].present?
    create_or_update_email_addresses(row['email2'], row['email2_type'], row['email2_status']) if row['email2'].present?
    create_or_update_email_addresses(row['email3'], row['email3_type'], row['email3_status']) if row['email3'].present?
    create_or_update_email_addresses(row['email4'], row['email4_type'], row['email4_status']) if row['email4'].present?
  end

  def construct_phone_numbers(row)
    # @phone_numbers << @person.phone_numbers.build(value: row['phone1'], phone_type: row['phone1_type']) if row['phone1'].present?
    # @phone_numbers << @person.phone_numbers.build(value: row['phone2'], phone_type: row['phone2_type']) if row['phone2'].present?
    # @phone_numbers << @person.phone_numbers.build(value: row['phone3'], phone_type: row['phone3_type']) if row['phon3'].present?
    # @phone_numbers << @person.phone_numbers.build(value: row['phone4'], phone_type: row['phone4_type']) if row['phone4'].present?
    create_or_update_phone_numbers(row['phone1'], row['phone1_type']) if row['phone1'].present?
    create_or_update_phone_numbers(row['phone2'], row['phone2_type']) if row['phone2'].present?
    create_or_update_phone_numbers(row['phone3'], row['phone3_type']) if row['phone3'].present?
    create_or_update_phone_numbers(row['phone4'], row['phone4_type']) if row['phone4'].present?
  end

  def create_or_update_phone_numbers(phone, type)
    PhoneNumber.find_or_create_by(value: phone, phone_type: type, person_id: @person.id)
  end

  def create_or_update_email_addresses(email, email_type, status)
    email_address = EmailAddress.find_or_create_by(email: email, email_type: email_type, person_id: @person.id)
    email_address.update(status: status) if email_address.present? && email_address&.id.present? 
  end

  def create_or_update_job_experiences(position, company_name, location, current)
    experience = JobExperience.find_by(title: position, company_name: company_name, location: location, person_id: @person.id)
    
    if experience.blank?
      JobExperience.create!(title: position, company_name: company_name, location: location, person_id: @person.id, present: current)
    else
      experience.update(present: current)
    end
  end

  def construct_education_experiences(row)
    user_education = row['education_experience'].split(',') if row['education_experience'].present?
    if user_education.present?
      user_education.each do |school|
        split_by_name = school.split('(')
        school_name = split_by_name[0]&.strip
        
        next if school_name.blank?

        from = nil
        to = nil

        if split_by_name[1].present?
          split_remaining_name = split_by_name[1].split('-')
          from = split_remaining_name[0]&.strip
          to = split_remaining_name[1].gsub(')', '')&.strip if split_remaining_name[1].present?
        end

        education_exp = EducationExperience.find_by(school_name: school_name, person_id: @person.id)
        
        if education_exp.blank?
          EducationExperience.create!(school_name: school_name, from: from, to: to, person_id: @person.id)
        else
          education_exp.update(from: from, to: to) if from.present? || to.present?
        end
        # @education_experience << @person.education_experiences.build(school_name: school_name, from: from, to: to)
      end
    end
  end
end


