FactoryBot.define do
  factory :shop do
    sequence(:name) { |n| "shop_#{n}" }
    sequence(:address) { |n| "東京都渋谷区神南#{n}-#{n}-#{n}" }
  end
end
