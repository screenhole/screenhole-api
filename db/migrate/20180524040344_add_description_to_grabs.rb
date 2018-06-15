class AddDescriptionToGrabs < ActiveRecord::Migration[5.1]
  def change
    add_column :grabs, :description, :text
  end
end
