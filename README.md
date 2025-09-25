# Share Alert

A Ruby application that scrapes ShareSansar.com for IPO and Right Share information and sends email alerts when new opportunities are available.

## Features

- 📈 Scrapes IPO data from ShareSansar.com
- 📧 Sends beautiful HTML email notifications via Brevo SMTP
- 🔒 Secure credential management with environment variables
- 📊 Professional email template with table formatting

## Local Setup

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
   ```

3. **Run the application:**
   ```bash
   ruby main.rb
   ```

## GitHub Actions Setup (Automated Cron Job)

To run this automatically on GitHub Actions:

1. **Push your code to GitHub repository**

2. **Set up GitHub Secrets:**
   - Go to your repository → Settings → Secrets and variables → Actions
   - Add the following secrets:
     - `BREVO_USERNAME`: Your Brevo SMTP username
     - `BREVO_PASSWORD`: Your Brevo SMTP password
     - `FROM_EMAIL`: Your sender email address

3. **Configure the schedule:**
   - Edit `.github/workflows/share-alert.yml`
   - Modify the cron expression to your preferred time
   - Current setting: `*/5 * * * *` (every 5 minutes)

4. **Manual trigger:**
   - Go to Actions tab in your GitHub repository
   - Select "Share Alert Cron Job" workflow
   - Click "Run workflow" to test

### Cron Schedule Examples:
```yaml
# Every day at 9 AM UTC
- cron: '0 9 * * *'

# Every weekday at 2 PM UTC
- cron: '0 14 * * 1-5'

# Twice daily: 9 AM and 6 PM UTC
- cron: '0 9,18 * * *'

# Every Monday, Wednesday, Friday at 10 AM UTC
- cron: '0 10 * * 1,3,5'
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
