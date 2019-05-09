FactoryBot.define do
  factory :grab_comment do
    user
    grab
    message { 'blah blah blah' }
  end
end
