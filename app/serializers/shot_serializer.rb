class ShotSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :image_public_url

  belongs_to :user
end