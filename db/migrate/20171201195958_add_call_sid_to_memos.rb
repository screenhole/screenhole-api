class AddCallSidToMemos < ActiveRecord::Migration[5.1]
  def change
    add_column :memos, :call_sid, :string
    add_index :memos, :call_sid, unique: true
  end
end
