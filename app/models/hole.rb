class Hole < ApplicationRecord

  HARD_BLACKLIST_REGEX = [
    # anti-impersonation
    /\Athinko.*/i,
    /\Ascreenhole.*/i,
    # trademark protection
    /lenovo/i
  ].freeze

  RULES = %i[chat_enabled chomments_enabled web_upload_enabled private_grabs_enabled].freeze

  has_many :grabs, dependent: :destroy
  has_many :chat_messages, dependent: :destroy

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

  HARD_BLACKLIST_REGEX.each do |r|
    validates_format_of :subdomain, without: r
  end

  def owner
    hole_memberships.order('created_at ASC').first.try(&:user)
  end

  def rules
    RULES.collect do |key|
      [key, public_send(key)]
    end.to_h
  end
end
