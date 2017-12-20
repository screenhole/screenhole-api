class UserSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :username, :created_at, :gravatar_hash, :name, :bio

  attribute :email, if: :is_current_user?

  has_many :shots
  has_many :notes, if: :is_current_user?

  attribute :stats

  def stats
    stats = {
      grabs: object.shots.size,
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