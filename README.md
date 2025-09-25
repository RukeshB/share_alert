# Share Alert

A Ruby application that scrapes ShareSansar.com for IPO and Right Share information and sends email alerts when new opportunities are available.

## Features

- 📈 Scrapes IPO data from ShareSansar.com
- 📧 Sends beautiful HTML email notifications via Brevo SMTP
- 🔒 Secure credential management with environment variables
- 📊 Professional email template with table formatting

## Setup

1. **Install dependencies:**
   ```bash
   bundle install
   ```

2. **Configure environment variables:**
   Create a `.env` file with the following variables:
   ```
   BREVO_USERNAME=your_brevo_username
   BREVO_PASSWORD=your_brevo_password
   FROM_EMAIL=your_sender_email
   TO_EMAIL=your_recipient_email
   ```

3. **Run the application:**
   ```bash
   ruby main.rb
   ```

## Project Structure

- `main.rb` - Main application entry point
- `share_sansar_scraper.rb` - Web scraper for ShareSansar.com
- `smtp.rb` - Email sending functionality
- `templates/email_template.erb` - HTML email template
- `.env` - Environment variables (not tracked in git)

## Requirements

- Ruby 2.7+
- Internet connection for web scraping
- Brevo SMTP account for email sending
