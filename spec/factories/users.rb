FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "test_user_#{n}" }
    sequence(:email) { |n| "testuser#{n}@screenhole.net" }
    sequence(:name) { |n| "test user #{n}"}

    password { 'cheeseboard' }
    password_confirmation { 'cheeseboard' }

    bio { 'how much wood could a wood chuck chuck if a wood chuck could chuck wood' }

    after(:create) do |user|
      user.buttcoin_transaction(20_000)
    end
  end
end
