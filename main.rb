require 'httparty'
require 'pry'
require 'nokogiri'
require 'dotenv'
require_relative 'share_sansar_scraper'

# Load environment variables
Dotenv.load('.env')

# Validate required environment variables
required_vars = %w[BREVO_USERNAME BREVO_PASSWORD FROM_EMAIL TO_EMAILS]
missing_vars = required_vars.select { |var| ENV[var].nil? || ENV[var].empty? }

if missing_vars.any?
  puts "❌ Missing required environment variables: #{missing_vars.join(', ')}"
  puts 'Please check your .env file'
  exit 1
end

# Parse multiple recipient emails from environment variable (comma-separated)
recipient_emails_string = ENV['TO_EMAILS']
RECIPIENT_EMAILS = recipient_emails_string.split(',').map(&:strip)

scraper = ShareSansarScraper.new

# Fetch and display IPOs
all_ipos = scraper.fetch_open_ipos
puts '=== All IPO Data ==='
puts "Total IPOs found: #{all_ipos.length}"

# Filter out closed IPOs (keep everything else)
open_upcoming_ipos = all_ipos.reject do |ipo|
  status = (ipo['Status'] || '').downcase
  status.include?('closed')
end

puts "\n=== Filtered IPO Data (Open/Upcoming) ==="
puts "Open/Upcoming IPOs: #{open_upcoming_ipos.length}"
open_upcoming_ipos.each_with_index do |ipo, index|
  puts "#{index + 1}. #{ipo['Company'] || 'N/A'} - Status: #{ipo['Status'] || 'N/A'}"
end

# Fetch financial news
puts "\n" + '=' * 50
puts '=== Fetching Financial News ==='
puts '=' * 50

news_data = scraper.fetch_financial_news

p news_data

puts "\n=== Financial News Titles ==="
puts "Found #{news_data.length} financial news articles"
news_data.each_with_index do |item, index|
  puts "#{index + 1}. #{item['Title']}"
end

ipos = open_upcoming_ipos

# Send email notification if open/upcoming IPOs or financial news are present
if ipos.any? || news_data.any?
  puts "\n=== Sending Email Notification ==="

  subject_parts = []
  subject_parts << "#{ipos.length} Open/Upcoming IPOs" if ipos.any?
  subject_parts << "#{news_data.length} Financial News" if news_data.any?
  subject = "🚨 Stock Alert - #{subject_parts.join(' & ')} Available!"

  success = Smtp.send_email(
    subject: subject,
    to: RECIPIENT_EMAILS,
    ipo_data: ipos,
    news_data: news_data
  )

  if success
    puts '✅ Email notification process completed!'
  else
    puts '❌ All email notifications failed'
  end
else
  puts "\nNo open IPOs or financial news found, no email sent."
end
