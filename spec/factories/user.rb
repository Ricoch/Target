FactoryBot.define do
  factory :user do
    email    { Faker::Internet.unique.email }
    password { Faker::Internet.password(8) }
    uid      { Faker::Number.unique.number(10) }
  end
end
