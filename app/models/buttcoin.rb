class Buttcoin < ApplicationRecord
  include Hashid::Rails

  belongs_to :user

  after_save :channel_broadcast

  AMOUNTS = {
    create_grab: 11,
    create_voice_memo: 9,
    receive_voice_memo: 13,
  }

  COSTS = {
    generate_invite: -200,
  }

  def channel_broadcast
    ActionCable.server.broadcast "buttcoins_messages", ActiveModelSerializers::SerializableResource.new(self).as_json
  end
end
