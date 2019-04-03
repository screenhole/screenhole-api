FactoryBot.define do
  factory :memo do
    variant { 'chomment' }
    media_path { '/butts' }
    message { 'wow this is awesome share thnx' }
    user
    grab
  end
end
