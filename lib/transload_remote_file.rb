require 'open-uri'

class TransloadRemoteFile
  def initialize(remote_url)
    @remote_url = remote_url
  end

  def remote_url
    URI.parse(URI.escape(@remote_url))
  end

  def upload_to_s3(object_path)
    open(remote_url) do |file|
      AWS_S3_BUCKET.object(object_path).put(body: file, acl: 'public-read')
    end
  end
end

# TransloadRemoteFile.new('https://example.com/foo.mp3').upload_to_s3('asdf/bar.mp3')
