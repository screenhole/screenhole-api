class UpdateCacheGrabsCount < ActiveRecord::Migration[5.1]
  def change
    User.find_each { |user| User.reset_counters(user.id, :grabs) }
  end
end
