class Note < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  belongs_to :actor, class_name: "User"
  belongs_to :cross_ref, polymorphic: true

  serialize :meta, Hash

  validates_presence_of :variant, :user

  after_save :channel_broadcast

  def channel_broadcast
    return unless can_broadcast?
    ActionCable.server.broadcast 'notes_channel', as_json
  end

  def can_broadcast?
    variant == 'chomment' || variant == 'at_reply'
  end
end
