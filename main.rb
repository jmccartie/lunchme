require 'rubygems'
require "bundler/setup"
require 'sinatra'
require 'json'
require 'yelpster'

get '/' do
  check_param(:zipcode) 
  content_type :json

  client = Yelp::Client.new
  request = Yelp::V1::Review::Request::Location.new(
    zipcode: params[:zipcode],
    term: 'lunch',
    yws_id: ENV['YWSID']
  )

  response = client.search(request)

  if response["message"]["text"] == "OK"
    results = []
    response["businesses"].map { |r| results << {name: r["name"], address: r["address1"], rating: r["avg_rating"]} }
    return_with_callback(results.to_json, params[:callback])
  else
    halt 500
  end
  
end



private

  def return_with_callback(data, callback = nil)
    callback.nil? ? data : "#{callback}(#{data});"
  end

  def check_param(param)
    halt 400 if params[param].nil? || params[param].empty?
  end