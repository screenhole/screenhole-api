class CreateChomments < ActiveRecord::Migration[5.1]
  def change
    create_table :chomments do |t|
      t.string :message

      t.timestamps
    end

    add_reference :chomments, :user, index: true
  end
end
