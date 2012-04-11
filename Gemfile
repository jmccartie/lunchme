source "http://rubygems.org"

gem "sinatra", "1.2.6"
gem "thin", "1.3.1"
gem "dalli", "1.0.5"
gem 'yelpster'

group :production do
  gem 'newrelic_rpm', "~> 3.3.0"
end

group :development do
  gem "shotgun"
  gem "guard", "~> 0.9.4"
  gem "guard-rspec"
  gem 'growl'
end

group :test do
  gem "rspec", "~> 2.6.0"
  gem "rack-test"
  gem "webmock"
end