class CreateMemos < ActiveRecord::Migration[5.1]
  def change
    create_table :memos do |t|
      t.integer :variant, default: 0

      t.string :media_path
      t.string :message

      t.timestamps
    end

    add_reference :memos, :user, index: true
    add_reference :memos, :shot, index: true
  end
end
