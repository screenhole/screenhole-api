class Hole < ApplicationRecord
  SUBDOMAIN_BLACKLIST = %w[www].freeze

  has_many :grabs, dependent: :destroy

  validates(
    :name,
    presence: true
  )

  validates(
    :subdomain,
    presence: true,
    format: /\A[a-z0-9\-]+\z/,
    length: { minimum: 3, maximum: 30 },
    exclusion: SUBDOMAIN_BLACKLIST
  )
end
