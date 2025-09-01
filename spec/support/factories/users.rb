FactoryBot.define do
  factory :user do
    first_name          { "Jane" }
    last_name           { "Doe" }
    sequence(:email)    { |n| "user#{n}@example.com" }
    password            { "password123" }
    total_lesson_minutes { 300 }
    role                { "student" }

    trait :teacher do
      role { "teacher" }
    end
  end
end
