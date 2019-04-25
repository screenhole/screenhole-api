# frozen_string_literal: true

# :nodoc:
class GrabSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at, :image_public_url, :description, :media_type, :accelerator_metadata

  belongs_to :user

  has_many :memos

  def is_current_user?
    defined? current_user && object.user_id == current_user.id
  end
end