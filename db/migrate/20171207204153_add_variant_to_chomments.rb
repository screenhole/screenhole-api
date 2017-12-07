class AddVariantToChomments < ActiveRecord::Migration[5.1]
  def change
    add_column :chomments, :variant, :integer, default: 0
  end
end
