class AddGrabsCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :grabs_count, :integer
  end
end
