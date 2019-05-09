# :nodoc:
class GrabSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at, :image_public_url, :description, :media_type, :accelerator_metadata

  belongs_to :user

  has_many :memos
  has_many :tips
  has_many :comments

  attribute(:tip_balance) { object.blended_tip_balance }
  attribute(:comment_count) { object.comments.count }
end
