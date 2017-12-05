#require 'httparty'

class Locator
  def initialize(ip)
    @ip = ip
    binding.pry
  end

  def get_zip
    response = HTTParty.get("http://freegeoip.net/json/#{@ip}")
  end
end