class UserSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :username, :created_at, :gravatar_hash, :name, :bio, :blocked

  attribute :email, if: :is_current_user?

  attribute :stats

  attribute :badges

  attribute :holes

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

  def holes
    object.holes.map { |h| HoleSerializer.new(h) }
  end

  def is_current_user?
    begin
      object.id == current_user.id
    rescue
      false
    end
  end
end
