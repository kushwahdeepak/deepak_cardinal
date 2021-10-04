FactoryBot.define do 
  factory :job_experience do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    start_date { Date.today }
    end_date {Date.today + 5.days}
    association(:person)
  end
end