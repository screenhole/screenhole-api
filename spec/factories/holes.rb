FactoryBot.define do
  factory :hole do
    sequence(:name) { |n| "Dummy Hole ##{n}" }
    sequence(:subdomain) { |n| "dummyhole#{n}" }
    transient do
      hole_memberships { [] }
    end

    after(:create) do |hole|
      create_list(:hole_membership, 3, hole: hole)
    end
  end
end
