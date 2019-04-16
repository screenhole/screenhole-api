class ChatMessageSerializer < ActiveModel::Serializer
  attributes :id, :message, :created_at

  belongs_to :hole
  belongs_to :user
end
