class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.belongs_to :user, foreign_key: { to_table: :users }
      t.belongs_to :actor, foreign_key: { to_table: :users }
      t.references :cross_ref, polymorphic: true
      t.string :variant
      t.text :meta

      t.timestamps
    end

    add_index :notes, :variant
  end
end
