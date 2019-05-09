FactoryBot.define do
  factory :grab_tip do
    grab
    user
    amount { 80_085 }
  end
end
