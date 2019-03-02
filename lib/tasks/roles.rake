STAFF = [
  'pasquale',
  'jacob',
  'wojtek',
  'josh'
].freeze

CONTRIBUTORS = [
  'pasquale',
  'jacob',
  'aleks',
  'wojtek',
  'josh',
  'boop'
].freeze

namespace :roles do
  task backfill: :environment do
    User.where(username: STAFF).each do |user|
      user.is_staff = true
      user.save!
    end

    User.where(username: CONTRIBUTORS).each do |user|
      user.is_contributor = true
      user.save!
    end
  end
end
