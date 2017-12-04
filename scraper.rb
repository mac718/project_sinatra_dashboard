require 'rubygems'
require 'mechanize'
require 'bundler/setup'
require 'pry'
require 'csv'
require_relative 'results_saver'

class Scraper

  attr_reader :search_terms, :location

  def initialize(search_terms, location)
    @scraper = Mechanize.new { |agent| 
          agent.user_agent_alias = "Linux Firefox"}
    @scraper.history_added = Proc.new { sleep 0.5 }
    @result_saver = ResultsSaver.new
    @search_terms = search_terms.split(' ').join('+OR+')
    @location = location
  end

  def organize_data
    @job_details_divs.map do |div|
      {
        company: div.at('a .compName').text.strip,
        location: div.at('span .jobLoc').text,
        title: div.at('h3 a').attributes['title'].value,
        link: div.at('h3 a').attributes['href'].value,
        posting_date: div.at('span[@itemprop = datePosted]').text,
        company_id: div.at('h3 a').attributes['href'].value.split("/")[4],
        job_id: (/[^?]*/).match(div.at('h3 a').attributes['href'].value.split("/")[5])[0]
      }
    end

  end

  def scrape
    @page_number = 1
    @page = @scraper.get("https://www.dice.com/jobs?q=#{@search_terms}&l=#{@location}&startPage=#{@page_number}")
    @job_details_divs = @page.search('.complete-serp-result-div')
    until @job_details_divs.empty?
      @result_saver.save_results(organize_data)
      @page_number += 1
      @page = @scraper.get("https://www.dice.com/jobs?q=#{@search_terms}&l=#{@location}&startPage=#{@page_number}")
      @job_details_divs = @page.search('.complete-serp-result-div')
    end 
  end
end
