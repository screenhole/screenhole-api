class ShotSerializer < ActiveModel::Serializer
  attribute :hashid, key: :id

  attributes :created_at, :image_public_url

  belongs_to :user
end