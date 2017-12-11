class CompanyProfiler

  BASE_URI = "http://api.glassdoor.com/"

  PARTNER_ID = ENV[:GLASSDOOR_PARTNER_ID]

  API_KEY = ENV[:GLASSDOOR_API_KEY]

  def initialize(company_name, user_agent)
    @company_name = company_name
    @user_agent = user_agent
  end

  def get_company_info
    HTTParty.new("#{BASE_URI}/api/api.htm?v=1&t.p=#{PARTNER_ID}&t.k=#{API_KEY}&userip=76.226.248.30&useragent=#{@user_agent}&format=json&v=1&action=employers&q=#{@company_name}")
  end
end