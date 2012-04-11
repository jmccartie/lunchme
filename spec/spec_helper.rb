require File.dirname(__FILE__) + '/../main'

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'webmock/rspec'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

WebMock.disable_net_connect!

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  @app ||= Sinatra::Application
end