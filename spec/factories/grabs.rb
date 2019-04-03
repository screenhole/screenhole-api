FactoryBot.define do
  factory :grab do
    image_path { '/butts' }
    description { 'hello there' }
    user
  end
end
