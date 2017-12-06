class UserSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :username, :created_at, :gravatar_hash

  attribute :email, if: :is_current_user?

  has_many :shots

  def is_current_user?
    begin
      object.id == current_user.id
    rescue
      false
    end
  end
end