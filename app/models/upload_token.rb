class UploadToken
  ALGORITHM = 'HS256'.freeze

  def initialize(user:)
    @user = user
  end

  def token
    JWT.encode(
      claim,
      accelerator_jwt_secret,
      ALGORITHM,
      headers
    )
  end

  def url
    "#{accelerator_endpoint}#{path}"
  end

  def path
    @path ||= "/#{user.hashid}/#{SecureRandom.hex(32)}"
  end

  def to_json(*args)
    {
      path: path,
      url: url,
      token: token
    }.to_json(*args)
  end

  private

  attr_reader :user

  def headers
    {
      kid: accelerator_kid
    }
  end

  def claim
    {
      method: 'PUT',
      url: url,
      exp: 1.hour.from_now.to_i,
      maxContentLength: 10.megabytes.to_i
    }
  end

  def accelerator_jwt_secret
    @accelerator_jwt_secret ||= Base64.decode64(
      ENV.fetch('ACCELERATOR_JWT_SECRET')
    )
  end

  def accelerator_kid
    @accelerator_kid ||= ENV.fetch('ACCELERATOR_KID')
  end

  def accelerator_endpoint
    @accelerator_endpoint ||= ENV.fetch(
      'ACCELERATOR_ENDPOINT',
      'https://screenhole.accelerator.net'
    )
  end
end
