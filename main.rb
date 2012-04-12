require 'rubygems'
require "bundler/setup"
require 'sinatra'
require 'json'
require 'dalli'
require 'digest/md5'
require 'yelpster'

cache = Dalli::Client.new(nil, {expires_in: 43200}) # 12 hours
set :cache, cache

# Production-only
configure :production do
  require 'newrelic_rpm'
end

get '/' do
  check_param(:zipcode) 
  halt 400 if params[:zipcode].to_i == 0
  content_type :json

  cache_key = Digest::MD5.hexdigest(params[:zipcode])
  data = settings.cache.get(cache_key)

  if data.nil?
    data = []

    client = Yelp::Client.new
    request = Yelp::V1::Review::Request::Location.new(
      zipcode: params[:zipcode],
      term: 'lunch',
      yws_id: ENV['YWSID']
    )
    response = client.search(request)

    if response["message"]["text"] == "OK"
      response["businesses"].map { |r| data << {name: r["name"], address: r["address1"], rating: r["avg_rating"], url: r["url"]} }
    else
      halt 500
    end

    data = data.to_json
    settings.cache.set(cache_key, data)
  end

  return_with_callback(data, params[:callback])
end



private

  def return_with_callback(data, callback = nil)
    callback.nil? ? data : "#{callback}(#{data});"
  end

  def check_param(param)
    halt 400 if params[param].nil? || params[param].empty?
  end