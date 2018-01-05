class GrabSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at, :image_public_url

  belongs_to :user

  has_many :memos

  def is_current_user?
    defined? current_user && object.user_id == current_user.id
  end
end