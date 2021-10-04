FactoryBot.define do 
  factory :person do 
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email_address { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.cell_phone }
    resume { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'incoming_mails', 'resume.pdf'), 'application/pdf') }
    company_names { Faker::Company.name }
    skills { 'C++, Javascript' }
    association(:user)
    # association(:organization)
  end
end