class AddAmountToGrabTips < ActiveRecord::Migration[5.2]
  def change
    add_column :grab_tips, :amount, :integer
  end
end
