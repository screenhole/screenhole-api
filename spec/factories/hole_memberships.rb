FactoryBot.define do
  factory :hole_membership do
    user
    hole
    owner { false }
  end
end
