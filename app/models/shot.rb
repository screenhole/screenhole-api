class Shot < ApplicationRecord
  include Hashid::Rails
  
  belongs_to :user

  validates_presence_of :image_path

  def image_public_url
    AWS_S3_BUCKET.object(image_path).public_url
    # "#{AWS_S3_BUCKET.url}/#{public_url}"
  end
end
