FactoryBot.define do
  factory :referral do
    association :user, strategy: :null
    association :job, strategy: :null
    invitee_name { Faker::Name.first_name }
    invitee_email { Faker::Internet.email }
  end
end
