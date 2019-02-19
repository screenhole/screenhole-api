source 'https://rubygems.org'
ruby File.read(File.expand_path('.ruby-version', __dir__)).chomp

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'bcrypt', '~> 3.1.7'
gem 'redis'
gem 'rack-cors'
gem 'knock'
gem 'aws-sdk-s3'
gem 'active_model_serializers'
gem 'hashid-rails'
gem 'kaminari'
gem 'sentry-raven'
gem 'skylight'
gem 'countries'
gem 'tzinfo'
gem 'tzinfo-data'
gem 'puma_worker_killer'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'bullet'
end

group :test do
  gem 'simplecov', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
