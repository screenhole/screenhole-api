FactoryBot.define do
  factory :invite do
    code { rand(36**8).to_s(36).downcase }
    user

    factory :invite_redeemed do
      invited_id { 123456789 }
    end
  end
end
