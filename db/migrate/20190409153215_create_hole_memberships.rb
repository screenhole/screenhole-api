class CreateHoleMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :hole_memberships do |t|
      t.belongs_to :hole, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.boolean :owner

      t.timestamps
    end
  end
end
