class Chomment < ApplicationRecord
  include Hashid::Rails
  
  belongs_to :user

  enum variant: [
    :generic,
    :voice_memo,
  ]

  validates_presence_of :message

  after_save :channel_broadcast

  def channel_broadcast
    ActionCable.server.broadcast "chomments_messages", ActiveModelSerializers::SerializableResource.new(self).as_json
  end
end
