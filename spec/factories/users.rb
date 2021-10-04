FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { '1234567!' }
    password_confirmation { '1234567!' }
    accepts { true }
    accepts_date { Date.today }
    role { :recruiter }

    trait :guest do
      role { :guest }
    end

    trait :employee do
      role { :employer }
    end

    trait :admin do
      role { :admin }
    end

    trait :employer do
      role { :employer }
    end

    trait :candidate do
      role { :talent }
    end
  end
end
