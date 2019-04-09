class HoleMembership < ApplicationRecord
  belongs_to :hole
  belongs_to :user
end
