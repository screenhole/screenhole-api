class MakeCountriesEmojis < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :emoji, :string

    User.all.each do |user|
      user.emoji = user.country_emoji
      user.save!
    end

    remove_column :users, :country_code
  end
end
