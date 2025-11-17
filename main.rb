require 'httparty'
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

ipos = open_upcoming_ipos

# Send email notification if open/upcoming IPOs are present
if ipos.any?
  puts "\n=== Sending Email Notification ==="
  success = Smtp.send_email(
    subject: "🚨 IPO Alert - #{ipos.length} Open/Upcoming IPOs Available!",
    to: RECIPIENT_EMAILS,
    ipo_data: ipos,
    right_data: []
  )

  if success
    puts '✅ Email notification process completed!'
  else
    puts '❌ All email notifications failed'
  end
else
  puts "\nNo open or upcoming IPOs found, no email sent."
end
