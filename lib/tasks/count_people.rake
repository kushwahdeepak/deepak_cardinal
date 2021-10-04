require 'rubygems'
require 'active_record'
require 'redis'

namespace :count_people do
  desc "Counts the people"
  task :count_people do
    # Connect to Redis
    redis = Redis.new

    # Update or reset DB foreign primary key index
    ActiveRecord::Base.connection.tables.each do |table_name|
      ActiveRecord::Base.connection.reset_pk_sequence!(table_name)
    end

    # Reindex the person records
    Person.find_in_batches(batch_size: 100) do |group|
      group.each do |person|
        # Remove blank people records as we go
        if person.first_name.nil? && person.last_name.nil? && person.formatted_name.nil? && person.crelate_id.nil? && person.lever_candidate_id.nil? && person.linkedin_profile_url.nil? && person.email_address.nil?
          person.save!
          person.destroy!
        else
          person.save!
          person.index!
        end

        # Might as well set email available as we go...
        if person.email_address.present?
          person.email_available = true
          person.save!
          person.index!
        else
          person.email_available = false
          person.save!
          person.index!
        end

        # ...and set phone number available
        if person.phone_number.present?
          person.phone_number_available = true
          person.save!
          person.index!
        else
          person.phone_number_available = false
          person.save!
          person.index!
        end
      end
    end

    # Count the people in DB
    total_people_count = Person.all.count
    active_people_count = Person.where(active: true).count

    # Set the people counts to be available in Redis
    redis.set("all_people_count", total_people_count)
    redis.set("active_people_count", active_people_count)
  end
end
