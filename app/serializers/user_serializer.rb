class UserSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :username, :created_at, :gravatar_hash

  attribute :email, if: :is_current_user?

  has_many :shots

  def is_current_user?
    defined? current_user && object.id == current_user.id
  end
end