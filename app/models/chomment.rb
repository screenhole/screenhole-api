class Chomment < ApplicationRecord
  include Hashid::Rails
  
  belongs_to :user

  belongs_to :cross_ref, polymorphic: true, optional: true

  enum variant: [
    :generic,
    :voice_memo,
  ]

  validates_presence_of :message

  after_save :channel_broadcast

  def at_replies
    message.scan(/@\w+/)
  end

  def at_replied_users
    users = []

    at_replies.each do |name|
      user = User.find_by(username: name[1..-1].downcase)
      users.push user if user.present?
    end

    users
  end

  def notify_at_replied_users
    at_replied_users.each do |replied_user|
      replied_user.create_activity(:at_reply, owner: self, recipient: self.user, params: { summary: self.message })
    end
  end

  def channel_broadcast
    ActionCable.server.broadcast "chomments_messages", ActiveModelSerializers::SerializableResource.new(self).as_json
  end
end
