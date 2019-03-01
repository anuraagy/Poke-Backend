source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Rails 
gem 'rails'
gem 'pg'
gem 'puma'
gem 'jbuilder'
gem 'config'
gem 'devise'
gem 'textacular'
gem 'rb-readline'
gem 'kaminari'
gem 'whenever'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'rack-cors', require: 'rack/cors'
gem 'active_model_serializers', '~> 0.10.0'
gem 'bootsnap'

# Validators
gem 'phonelib'

# Networking/APIs
gem 'httparty'
gem 'rpush'
gem 'jwt'
gem 'sendgrid-ruby'

# Testing
gem "rspec"
gem 'rspec-rails'
gem "factory_bot_rails"
gem 'faker'

gem 'twilio-ruby'
gem 'redis'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'pry'
end

group :development do
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
