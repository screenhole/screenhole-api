class Hole < ApplicationRecord
  has_many :grabs, dependent: :destroy
  has_many :hole_memberships
  has_many :users, through: :hole_memberships

  validates(
    :name,
    presence: true
  )

  validates(
    :subdomain,
    presence: true,
    format: /\A[a-z0-9\-]+\z/,
    length: { minimum: 3, maximum: 30 },
    exclusion: Blacklist.words
  )

  def owner
    hole_memberships.order('created_at ASC').first.try(&:user)
  end
end
