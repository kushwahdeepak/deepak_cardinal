FactoryBot.define do
  factory :blacklist do
    association(:user)
    association(:person)
  end
end

