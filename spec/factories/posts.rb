FactoryBot.define do
  factory :post do
    date_of_post { Faker::Date.between(from: 31.days.ago, to: Time.now) }
    price        { Faker::Number.between(from: 1, to: 100_000) }
    memo1       { Faker::Lorem.word }
    memo2       { Faker::Lorem.word }
    association :user
  end
end
