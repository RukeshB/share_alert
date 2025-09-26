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
ipos = scraper.fetch_open_ipos
puts '=== IPO Data ==='
puts ipos

# Send email notification if IPOs are present
if ipos.any?
  puts "\n=== Sending Email Notification ==="
  success = Smtp.send_email(
    subject: 'Share Alert - New IPOs Available!',
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
  puts "\nNo IPOs found, no email sent."
end
