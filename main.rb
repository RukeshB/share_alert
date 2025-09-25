require 'httparty'
require 'nokogiri'
require_relative 'share_sansar_scraper'

scraper = ShareSansarScraper.new

# Fetch and display IPOs
ipos = scraper.fetch_open_ipos
puts '=== IPO Data ==='
puts ipos
