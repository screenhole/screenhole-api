class AddLastRequestedToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sup_last_requested_at, :datetime
    add_index :notes, :created_at
  end
end
