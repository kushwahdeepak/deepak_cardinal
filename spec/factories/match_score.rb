FactoryBot.define do
  factory :match_score do
    association :person
    association :job
    score { 0 }
  end
end