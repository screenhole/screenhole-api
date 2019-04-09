class RemoveOwnerFromHoleMemberships < ActiveRecord::Migration[5.2]
  def change
    remove_column :hole_memberships, :owner, :boolean
  end
end
