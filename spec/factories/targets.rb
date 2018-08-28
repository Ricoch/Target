FactoryBot.define do
  factory :target do
    longitude { Faker::Number.decimal(3, 7) }
    latitude  { Faker::Number.decimal(2, 7) }
    radius    { Faker::Number.number(5) }
    title     { Faker::Lorem.word }
    topic     { Faker::Number.between(0, 8) }
    user
  end
end
