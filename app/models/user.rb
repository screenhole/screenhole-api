class User < ApplicationRecord
  POTENTIAL_AWARDS = [
    ChatterboxAward,
    ContributorAward,
    NewbieAward,
    OversharerAward,
    ZimmerFrameAward
  ].freeze
  DEFAULT_COUNTRY_EMOJI = '🏁'.freeze

  include Hashid::Rails

  validates_uniqueness_of :username, case_sensitive: false, allow_blank: false
  validates_uniqueness_of :email, case_sensitive: false, allow_blank: false

  validates_presence_of :username, :email

  has_secure_password
  validates_length_of :password, minimum: 6, if: :password_digest_changed?
  validates_presence_of :password_confirmation, if: :password_digest_changed?

  validates_inclusion_of :country_code, allow_blank: true, in: ISO3166::Country.codes

  has_many :grabs, dependent: :destroy
  has_many :chomments, dependent: :destroy
  has_many :memos, dependent: :destroy

  has_many :notes
  has_many :invites

  before_validation :normalize_username

  scope :visible_in_directory, -> {
    left_joins(:grabs).
    group(:id).
    having('COUNT(grabs.id) >= 5').
    order('COUNT(grabs.id) DESC')
  }

  def buttcoin_transaction(amount, note=nil)
    Buttcoin.create(user: self, amount: amount, note: note)
  end

  def buttcoin_balance
    Buttcoin.where(user: self).sum(:amount)
  end

  def gravatar_hash
    Digest::MD5.hexdigest(email || "")
  end

  def to_token_payload
    { sub: hashid }
  end

  def country_emoji
    ISO3166::Country[country_code].try(:emoji_flag) || DEFAULT_COUNTRY_EMOJI
  end

  def awards
    POTENTIAL_AWARDS.map do |klass|
      award = klass.new(self)

      next unless award.eligible?

      {
        id: award.id,
        title: award.title,
        description: award.description,
        metadata: award.metadata
      }
    end.reject(&:nil?)
  end

  def self.from_token_payload(payload)
    if payload && payload["sub"]
      self.find payload["sub"]
    else
      begin
        _decoded_token = Base64.decode64(payload)
        _token = Knock::AuthToken.new(token: _decoded_token)
        if _token.payload && _token.payload["sub"]
          self.find _token.payload["sub"]
        else
          fail 'Missing sub payload'
        end
      rescue
        return nil
      end
    end
  end

  def self.from_token_request(request)
    username = request.params["auth"] && request.params["auth"]["username"]
    self.find_by(username: username)
  end

  private
  def normalize_username
    self.username = username.strip.downcase if username
  end
end
