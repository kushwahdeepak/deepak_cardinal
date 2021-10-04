FactoryBot.define do
  factory :stage_transition do
    association :submission
    feedback { 'Test Feedback'}
    stage { :reject }

    trait :first_interview do
      stage { :first_interview}
    end

    trait :lead do
      stage { :lead}
    end

    trait :second_interview do
      stage { :second_interview}
    end

    trait :offer do
      stage { :offer}
    end

    trait :reject do
      stage { :reject}
    end
  end
end
