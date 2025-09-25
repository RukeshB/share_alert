require 'httparty'
require 'nokogiri'
require 'dotenv'
require_relative 'share_sansar_scraper'

# Load environment variables
Dotenv.load('.env')

# Validate required environment variables
required_vars = ['BREVO_USERNAME', 'BREVO_PASSWORD', 'FROM_EMAIL']
missing_vars = required_vars.select { |var| ENV[var].nil? || ENV[var].empty? }

if missing_vars.any?
  puts "❌ Missing required environment variables: #{missing_vars.join(', ')}"
  puts "Please check your .env file"
  exit 1
end

# Configuration - you can modify this as needed
RECIPIENT_EMAIL = 'rukeshbasukala@gmail.com'

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
    to: RECIPIENT_EMAIL,
    ipo_data: ipos,
    right_data: []
  )

  if success
    puts '✅ Email sent successfully!'
  else
    puts '❌ Failed to send email'
  end
else
  puts "\nNo IPOs found, no email sent."
end
