FactoryBot.define do
  factory :task do
    name { Faker::Lorem.sentence }
    project
  end
end
