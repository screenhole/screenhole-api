class AddRolesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_contributor, :boolean
    add_column :users, :is_staff, :boolean
  end
end
