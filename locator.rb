#require 'httparty'

class Locator
  def initialize(ip)
    @ip = ip
  end

  def get_zip
    response = HTTParty.get("http://freegeoip.net/json/#{@ip}")
  end
end