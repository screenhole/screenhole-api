class Memo < ApplicationRecord
  include Hashid::Rails

  default_scope { order(created_at: :asc) }

  belongs_to :user
  belongs_to :grab

  enum variant: [
    :generic,
    :voice,
  ]

  before_create :generate_calling_code
  after_save :channel_broadcast

  def media_public_url
    return "" if self.media_path.blank?
    return self.media_path if self.media_path.start_with? "http"
    AWS_S3_BUCKET.object(self.media_path).public_url
  end

  def generate_calling_code
    # actual code is 5 digits. trailing digits denote env.
    # e.g. 11111 is prod, 111119 is staging.
    self.calling_code = SecureRandom.random_number(10000..99999)
    generate_calling_code if Memo.exists?(calling_code: self.calling_code)
  end

  def channel_broadcast
    ActionCable.server.broadcast "memos_messages", ActiveModelSerializers::SerializableResource.new(self).as_json
  end
end
