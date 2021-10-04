FactoryBot.define do 
  factory :incoming_mail do 
    plain {File.read("#{Rails.root}/spec/fixtures/incoming_mails/plain.txt")}
    candidate_email { "candidatemail@mail.com" }
    subject { Faker::Lorem.characters(number: 32) }
    
    trait :submission do 
      subject { "[2] from Chris Evans" }
      attachment { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'incoming_mails', 'resume.pdf'), 'application/pdf') }
    end

    trait :linkedin_submission do 
      from { ENV.fetch("INCOMING_GATEWAY_ADDRESS") }
    end

  end
end