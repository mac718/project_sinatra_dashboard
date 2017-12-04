require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'json'
require 'pry'
require 'thin'
require_relative 'scraper.rb'

enable :sessions

get '/' do 
  erb :index
end

post '/results' do 
  @scraper = Scraper.new(params[:search_terms], params[:location])
  File.open("results.csv") { |f| @results = f.readlines }
  erb :results
end