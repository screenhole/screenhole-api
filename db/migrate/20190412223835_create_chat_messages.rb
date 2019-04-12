class CreateChatMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_messages do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :hole, foreign_key: true
      t.string :message

      t.timestamps
    end
  end
end
