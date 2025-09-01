FactoryBot.define do
  factory :user_lesson do
    association :student, factory: [ :user, :student ]
    association :lesson
    clock_out_time { nil }

    trait :with_clock_out do
      clock_out_time { Time.current }
    end
  end
end
