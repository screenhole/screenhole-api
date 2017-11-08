class ShotSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at, :image_public_url

  belongs_to :user

  def is_current_user?
    defined? current_user && object.id == current_user.id
  end
end