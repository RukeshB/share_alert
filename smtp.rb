require 'mail'
require 'dotenv'
require 'erb'
require 'active_support/core_ext/hash/indifferent_access'

# Load environment variables
Dotenv.load('.env')

Mail.defaults do
  delivery_method :smtp, {
    address: 'smtp-relay.brevo.com',
    port: 587,
    domain: 'gmail.com',
    user_name: ENV['BREVO_USERNAME'],
    password: ENV['BREVO_PASSWORD'],
    authentication: :login,
    enable_starttls_auto: true
  }
end

class Smtp
  def self.send_email(subject:, to:, ipo_data:, right_data:)
    # Handle both single email and multiple emails
    recipients = to.is_a?(Array) ? to : [to]
    
    # Validate inputs
    if recipients.empty? || recipients.any? { |email| email.nil? || email.strip.empty? }
      puts '❌ Error: Valid recipient email(s) required'
      return false
    end

    if ENV['FROM_EMAIL'].nil? || ENV['FROM_EMAIL'].empty?
      puts '❌ Error: FROM_EMAIL environment variable is required'
      return false
    end

    puts "📧 Preparing to send email to #{recipients.length} recipient(s)"
    puts "📋 Subject: #{subject}"
    puts "📊 IPO data count: #{ipo_data&.length || 0}"
    puts "🔄 Right share data count: #{right_data&.length || 0}"

    template = File.read('templates/email_template.erb')
    renderer = ERB.new(template)
    html_content = renderer.result(binding)

    success_count = 0
    
    recipients.each do |recipient_email|
      puts "📤 Sending to: #{recipient_email}"
      
      begin
        mail = Mail.new do
          from    ENV['FROM_EMAIL']
          to      recipient_email.strip
          subject subject
          html_part do
            content_type 'text/html; charset=UTF-8'
            body html_content
          end
        end

        mail.deliver!
        puts "✅ Email sent successfully to #{recipient_email}!"
        success_count += 1
      rescue StandardError => e
        puts "❌ Email failed for #{recipient_email}: #{e.message}"
        puts "Error details: #{e.backtrace.first(3)}"
      end
    end
    
    puts "📊 Summary: #{success_count}/#{recipients.length} emails sent successfully"
    success_count > 0  # Return true if at least one email was sent
  end
end
