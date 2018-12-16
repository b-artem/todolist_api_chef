FactoryBot.define do
  factory :comment do
    text { Faker::Lorem.sentence }
    task
  end
end
