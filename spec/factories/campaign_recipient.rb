FactoryBot.define do
  factory :campaign_recipient do
    contact_recipient_at { Date.today + 1.day }
    recipient_id { Faker::Number.within(range: 1..10) }
    campaign_id { Faker::Number.within(range: 1..10) }
  end
end
