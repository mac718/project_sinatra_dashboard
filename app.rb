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
  @locator = Locator.new("76.226.248.30")
  @location = @locator.get_zip
  
  session[:user_city] = @location.parsed_response['city']
  session[:user_state] = @location.parsed_response['region_code']
  session[:user_zip] = @location.parsed_response['zip_code']
  @user_zip = session[:user_zip]
  erb :index
end

post '/results' do 
  binding.pry
  @user_zip = session[:user_zip]
  @user_agent = request["user_agent"]
  #@scraper = Scraper.new(params[:search_terms], @user_zip)
  #@scraper.scrape
  @location_city = session[:user_city]
  @location_state = session[:user_state]
  File.open("results.csv") { |f| @results = f.readlines }
  erb :results
end