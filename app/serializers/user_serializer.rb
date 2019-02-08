class UserSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :username, :created_at, :gravatar_hash, :name, :bio, :blocked

  attribute :country_code
  attribute :country_emoji

  attribute :email, if: :is_current_user?

  # has_many :grabs
  has_many :notes, if: :is_current_user?

  attribute :stats

  attribute :roles

  def roles
    roles = []

    roles.push('admin') if [0,1,6].index(object.id) != nil

    roles
  end

  def stats
    stats = {
      grabs: object.grabs.size,
    }

    # private stats
    if is_current_user?
      stats[:buttcoins] = object.buttcoin_balance
    end

    stats
  end

  def is_current_user?
    begin
      object.id == current_user.id
    rescue
      false
    end
  end
end
