class AddHoleToInvites < ActiveRecord::Migration[5.2]
  def change
    add_reference :invites, :hole, foreign_key: true
  end
end
