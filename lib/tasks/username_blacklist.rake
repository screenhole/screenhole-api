namespace :username_blacklist do
  task enforce: :environment do
    User.where(username: User::USERNAME_BLACKLIST).each do |user|
      user.username = "naughty_#{user.username}"
      user.save!
    end
  end
end
