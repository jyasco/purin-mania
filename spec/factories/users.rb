FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user_#{n}san" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
