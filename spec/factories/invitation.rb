FactoryBot.define do
  factory :invitation do
    association :organization
    association :inviting_user, factory: :user
    association :invited_user, factory: :user
  end
end

