class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.belongs_to :user, foreign_key: { to_table: :users }
      t.belongs_to :actor, foreign_key: { to_table: :users }
      t.references :cross_ref, polymorphic: true
      t.string :key
      t.text :meta

      t.timestamps
    end

    add_index :notes, :key
  end
end
