if Rails.env.development?
  Aws.config.update({
    region: 'us-east-1',
    :endpoint => 'http://fakes3.test:4567/',
    credentials: Aws::Credentials.new('FAKE_AWS_KEY', 'FAKE_AWS_SECRET')
  })
else
  Aws.config.update({
    region: 'us-east-1',
    credentials: Aws::Credentials.new(ENV['AWS_KEY'], ENV['AWS_SECRET'])
  })
end

AWS_S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['AWS_S3_BUCKET'] || '--BUCKET_NAME_MISSING--')
