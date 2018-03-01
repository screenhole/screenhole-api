class CreateInvites < ActiveRecord::Migration[5.1]
  def change
    create_table :invites do |t|
      t.references :user, index: true
      t.integer :invited_id, null: true

      t.string :code

      t.timestamps
    end

    add_index :invites, :code, unique: true
  end
end
