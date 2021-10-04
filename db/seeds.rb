# puts 'Seeding test users'
# User.destroy_all
# (1...50).each do |i|
#   User.create!(email: "person#{i}@test.com", password: '1234567!', password_confirmation: '1234567!', accepts: true, accepts_date: Date.today, role: ["admin", "talent", "recruiter", "employer"].sample, organization_id: 1)
# end

# puts 'Seeding test persons'
# Person.destroy_all
# (1...50).each do |i|
#   Person.create!(email_address: "person#{i}@test.com", skills: ["ruby", "rails", "React", "java"].sample, first_name: 'Person', last_name: i.to_s)
# end

# puts 'Seeding test jobs'
# Job.destroy_all
# (1...50).each do |i|
#   Job.create!(creator_id: 1, skills: ["ruby", "rails", "React", "java"].sample, name: ["ruby", "rails", "React", "java"].sample + ' Developer')
# end

# puts 'Seeding test submissions'
# Submission.destroy_all
# (1...50).each do |i|
#   (1...50).each do |j|
#     Submission.create!(person_id: i, user_id: i, job_id: j)
#   end
# end

# puts "Seeding test organizations"
# Organization.destroy_all
# (1...5).each do |i|
#   Organization.create!(owner_id: 1, name: "Organization ##{i}", description: "Test")
# end

# puts "Seeding test locations"
# Location.find_or_create_by!(country: 'Remote')
# Location.find_or_create_by!(country: 'Other')

# CS.countries.keys.map do |country_code|
#   Location.find_or_create_by!(
#     country: CS.countries[country_code],
#     state: 'Remote'
#   )
#   Location.find_or_create_by!(
#     country: CS.countries[country_code],
#     state: 'Other'
#   )

#   CS.states(country_code).keys.map do |state_code|
#     Location.find_or_create_by!(
#       country: CS.countries[country_code],
#       state: CS.states(country_code)[state_code],
#       city: 'Remote'
#     )
#     Location.find_or_create_by!(
#       country: CS.countries[country_code],
#       state: CS.states(country_code)[state_code],
#       city: 'Other'
#     )
#     CS.cities(state_code, country_code).map do |city|
#       Location.find_or_create_by!(
#       country: CS.countries[country_code],
#       state: CS.states(country_code)[state_code],
#       city: city
#     )
#     end
#   end
# end
