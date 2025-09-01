FactoryBot.define do
  factory :user do
    first_name          { "Jane" }
    last_name           { "Doe" }
    sequence(:email)    { |n| "user#{n}@example.com" }
    password            { "password123" }
    total_lesson_hours  { 5 }
    role                { "student" }

    trait :teacher do
      role { "teacher" }
    end
  end
end
