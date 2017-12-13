class UserSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :username, :created_at, :gravatar_hash, :name, :bio

  attribute :email, if: :is_current_user?

  has_many :shots

  attribute :stats

  def stats
    {
      grabs: object.shots.size
    }
  end

  def is_current_user?
    begin
      object.id == current_user.id
    rescue
      false
    end
  end
end