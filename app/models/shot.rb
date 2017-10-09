class Shot < ApplicationRecord
  belongs_to :user

  def image_public_url
    S3_BUCKET.object(image_path).public_url
    # "#{S3_BUCKET.url}/#{public_url}"
  end
end
