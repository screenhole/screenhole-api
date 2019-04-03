FactoryBot.define do
  factory :note do
    user
    association :actor, factory: :user
    association :cross_ref, factory: :memo
    meta { { summary: 'wow this is awesome share thnx' } }
    variant { 'chomment' }
  end
end
