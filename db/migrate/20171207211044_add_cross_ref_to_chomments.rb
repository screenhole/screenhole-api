class AddCrossRefToChomments < ActiveRecord::Migration[5.1]
  def change
    add_reference :chomments, :cross_ref, polymorphic: true
  end
end
