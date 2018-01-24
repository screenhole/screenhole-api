class AddBlockedToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :blocked, :text, array: true, default: []
  end
end
