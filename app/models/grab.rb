# :nodoc:
class Grab < ApplicationRecord
  include Hashid::Rails
  enum media_type: %i[image recording]

  belongs_to :hole, optional: true

  belongs_to :user, counter_cache: true

  has_many :memos, dependent: :destroy

  validates_presence_of :image_path

  after_destroy :delete_media

  after_create :hydrate_accelerator_metadata
  after_create :broadcast_via_cable
  after_create :credit_buttcoins

  def self.feed(page:, per_page: 25, hole: nil, user_id: nil)
    if user_id.present?
      return User.find(user_id)
                 .grabs
                 .page(page)
                 .per(per_page)
                 .reverse_order
    end

    grabs = Grab.includes(:user, :memos)

    grabs = if hole.present?
              grabs.where(hole_id: hole.id)
            else
              grabs.where(hole_id: nil)
            end

    grabs.page(page).per(per_page).reverse_order
  end

  def image_public_url(direct = false)
    url = AWS_S3_BUCKET.object(image_path).public_url
    url.gsub!('s3.amazonaws.com', 'accelerator.net') unless direct
    url
  end

  private

  def delete_media
    obj = AWS_S3_BUCKET.object(image_path)
    obj.delete
  end

  def broadcast_via_cable
    channel_name = hole.present? ? hole.cable_channel_name('grabs') : 'grabs_messages'

    ActionCable.server.broadcast(
      channel_name,
      ActiveModelSerializers::SerializableResource.new(self).as_json
    )
  end

  def credit_buttcoins
    user.buttcoin_transaction(
      Buttcoin::AMOUNTS[:create_grab],
      "Created Grab #{hashid}"
    )
  end

  def hydrate_accelerator_metadata
    metadata = JSON.parse(
      HTTParty.get(
        "#{image_public_url};metadata.json",
        format: :plain
      )
    )

    update_attribute(:accelerator_metadata, metadata)
  rescue StandardError
  end
end
