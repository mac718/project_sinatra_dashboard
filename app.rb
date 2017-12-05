require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'json'
require 'pry'
require 'thin'
require 'httparty'
require_relative 'scraper.rb'
require_relative 'locator.rb'

enable :sessions

get '/' do 
  erb :index
end

post '/results' do 
  #@scraper = Scraper.new(params[:search_terms], params[:location])
  File.open("results.csv") { |f| @results = f.readlines }
  binding.pry
  @locator = Locator.new("76.226.248.30")
  @location = @locator.get_zip
  @location_city = @location.parsed_response['city']
  @location_state = @location.parsed_response['region_code']
  erb :results
end