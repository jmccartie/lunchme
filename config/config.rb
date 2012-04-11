# Global config
configure do
  if url = ENV['DEVICE_ATLAS_FILE']
    set :da_setup, DaSetup.new(url)
  end
  set :cache, Dalli::Client.new
end

# Production-only
configure :production do
  require 'newrelic_rpm'
  require 'rack-ssl-enforcer'
  use Rack::SslEnforcer
end

# HTTP Auth
use Rack::Auth::Basic, "Restricted Area" do |username, password|
  [username, password] == [ENV['USERNAME'], ENV['PASSWORD']]
end

not_found do
  content_type :json
  {error: "Not Found"}.to_json
end