class AddEmailToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :email, :string
    add_index :users, :email, unique: true
  end
end
