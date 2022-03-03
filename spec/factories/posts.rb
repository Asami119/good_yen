FactoryBot.define do
  factory :post do
    date_of_post { Faker::Date.between(from: 31.days.ago, to: Date.today) }
    price        { Faker::Number.between(from: 1, to: 100000) }
    memo_1       { Faker::Lorem.word }
    memo_2       { Faker::Lorem.word }
    association :user
  end
end
