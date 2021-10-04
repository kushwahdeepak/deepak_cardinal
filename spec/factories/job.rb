FactoryBot.define do
  factory :job do
    name { Faker::Lorem.sentence }
    portalcompanyname { Faker::Company.name }
    compensation { Faker::Number.number(digits: 4) }
    created_at { Date.today }
    association :user
  end
end
