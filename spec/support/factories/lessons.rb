FactoryBot.define do
  factory :lesson do
    start_time { 1.hour.ago }
    subject    { "Math 101" }
    content    { "Algebra basics" }
    association :teacher, factory: [ :user, :teacher ]
  end
end
