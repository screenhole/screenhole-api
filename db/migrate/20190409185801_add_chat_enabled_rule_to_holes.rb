class AddChatEnabledRuleToHoles < ActiveRecord::Migration[5.2]
  def change
    add_column :holes, :chat_enabled, :boolean, default: false
  end
end
