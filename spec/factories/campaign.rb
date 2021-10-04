FactoryBot.define do
  factory :campaign do
    start_date { Date.today }
    duration_days { Faker::Number.within(range: 1..10) }
    source_address { Faker::Internet.email }
    subject {  Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    user_id { Faker::Number.within(range: 1..10) }
    job_id { Faker::Number.within(range: 1..10) }
  end
end
