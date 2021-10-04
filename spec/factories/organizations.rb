FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    owner { association(:user) }
    description { 'Test Description' }
  end
end

