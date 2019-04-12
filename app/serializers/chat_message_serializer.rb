class ChatMessageSerializer < ActiveModel::Serializer
  attributes :id, :message

  belongs_to :hole
  belongs_to :user
end
