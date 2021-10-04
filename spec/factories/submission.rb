FactoryBot.define do 
  factory :submission do 
    association :user
    association :person, strategy: :null
    association :job, strategy: :null
    association :incoming_mail, strategy: :null
  end
end
