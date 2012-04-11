require 'open-uri'
require 'net/http'
require File.dirname(__FILE__) + '/device_atlas'

class DaSetup

  def initialize(url)
    if remote_file_exists?(url)
      @@device_atlas = DeviceAtlas.new
      puts "==> Downloading Device Atlas file..."
      writeOut = open("/tmp/device_atlas.json", "w")
      writeOut.write(open(url).read)
      writeOut.close
      @@device_atlas_tree = @@device_atlas.getTreeFromFile("/tmp/device_atlas.json")
      puts "==> Device Atlas file saved."
    else
      raise "Remote Device Atlas file not found. Please check the URL and try again."
      exit
    end
  end

  def get_properties(ua)
    @@device_atlas.getProperties(@@device_atlas_tree, ua)
  end


  private
    def remote_file_exists?(url)
      url = URI.parse(url)
      Net::HTTP.start(url.host, url.port) do |http|
        return http.head(url.request_uri).code == "200"
      end
    end

end