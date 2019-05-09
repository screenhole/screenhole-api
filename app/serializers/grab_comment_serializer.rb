class GrabCommentSerializer < ActiveModel::Serializer
  attributes :created_at, :message

  belongs_to :user
  belongs_to :grab
end
