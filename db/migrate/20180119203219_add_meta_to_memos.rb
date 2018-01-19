class AddMetaToMemos < ActiveRecord::Migration[5.1]
  def change
    add_column :memos, :meta, :text
  end
end
