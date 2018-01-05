class RenameShotsToGrabs < ActiveRecord::Migration[5.1]
  def change
    rename_table :shots, :grabs
    rename_column :memos, :shot_id, :grab_id
  end
end
