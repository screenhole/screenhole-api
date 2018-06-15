class Grab < ApplicationRecord
  include Hashid::Rails

  belongs_to :user, counter_cache: true

  has_many :memos, dependent: :destroy

  validates_presence_of :image_path

  after_destroy :delete_media

  def image_public_url(direct=false)
    url = AWS_S3_BUCKET.object(image_path).public_url
    url.gsub!('s3.amazonaws.com', 'accelerator.net') unless direct
    url
  end

  private

    def delete_media
      obj = AWS_S3_BUCKET.object(image_path)
      obj.delete
    end
end
