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
    # Validate inputs
    if to.nil? || to.empty?
      puts '❌ Error: Recipient email is required'
      return false
    end

    if ENV['FROM_EMAIL'].nil? || ENV['FROM_EMAIL'].empty?
      puts '❌ Error: FROM_EMAIL environment variable is required'
      return false
    end

    puts "📧 Preparing to send email to: #{to}"
    puts "📋 Subject: #{subject}"
    puts "📊 IPO data count: #{ipo_data&.length || 0}"
    puts "🔄 Right share data count: #{right_data&.length || 0}"

    template = File.read('templates/email_template.erb')
    renderer = ERB.new(template)
    html_content = renderer.result(binding)

    mail = Mail.new do
      from    ENV['FROM_EMAIL']
      to      to
      subject subject
      html_part do
        content_type 'text/html; charset=UTF-8'
        body html_content
      end
    end

    mail.deliver!
    puts "Email sent successfully to #{to}!"
    true
  rescue StandardError => e
    puts "Email failed: #{e.message}"
    puts "Error details: #{e.backtrace.first(5)}"
    false
  end
end
