class AddRuleFieldsToHoles < ActiveRecord::Migration[5.2]
  def change
    add_column :holes, :chomments_enabled, :boolean, default: false
    add_column :holes, :web_upload_enabled, :boolean, default: false
    add_column :holes, :private_grabs_enabled, :boolean, default: false
  end
end
