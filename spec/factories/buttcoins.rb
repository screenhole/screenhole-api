FactoryBot.define do
  factory :buttcoin do
    note { 'buttcoin test' }
    amount { 1 }
    user

    factory :buttcoin_millionaire do
      amount { 1_000_000 }
    end

    factory :buttcoin_invite do
      amount { Buttcoin::AMOUNTS[:generate_invite] }
    end

    factory :buttcoin_grab do
      amount { Buttcoin::AMOUNTS[:create_grab] }
    end

    factory :buttcoin_chomment do
      amount { Buttcoin::AMOUNTS[:create_chomment] }
    end
  end
end
