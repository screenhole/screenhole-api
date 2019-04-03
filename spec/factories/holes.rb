FactoryBot.define do
  factory :hole do
    sequence(:name) { |n| "Dummy Hole ##{n}" }
    sequence(:subdomain) { |n| "dummyhole#{n}" }
  end
end
