class Note < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  belongs_to :actor, class_name: "User"
  belongs_to :cross_ref, polymorphic: true

  default_scope { order(created_at: :desc) }

  serialize :meta, Hash

  validates_presence_of :variant, :user

  after_save :channel_broadcast

  def channel_broadcast
    return unless can_broadcast?

    serialized_data = ActiveModelSerializers::SerializableResource.new(self)
    serialized_json_data = serialized_data.as_json

    ActionCable.server.broadcast 'notes_channel', serialized_json_data
  end

  def can_broadcast?
    variant == 'chomment' || variant == 'at_reply'
  end
end
