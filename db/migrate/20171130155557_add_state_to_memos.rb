class AddStateToMemos < ActiveRecord::Migration[5.1]
  def change
    add_column :memos, :pending, :boolean, default: true
    add_column :memos, :calling_code, :integer

    add_index :memos, :calling_code
  end
end
