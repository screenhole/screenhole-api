class Shot < ApplicationRecord
  include Hashid::Rails
  
  belongs_to :user

  has_many :memos, dependent: :destroy

  validates_presence_of :image_path

  after_destroy :delete_media

  def image_public_url
    AWS_S3_BUCKET.object(image_path).public_url
    # "#{AWS_S3_BUCKET.url}/#{public_url}"
  end

  private

    def delete_media
      obj = AWS_S3_BUCKET.object(image_path)
      obj.delete
    end
end
