# Share Alert

A Ruby application that scrapes ShareSansar.com for IPO and Right Share information and sends email alerts when new opportunities are available.

## Features

- 📈 Scrapes IPO data from ShareSansar.com
- 📧 Sends beautiful HTML email notifications via Brevo SMTP
- � **Multiple email recipients** support
- �🔒 Secure credential management with environment variables
- 📊 Professional email template with table formatting
- ⚡ Automated scheduling via GitHub Actions

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
   TO_EMAILS=recipient1@gmail.com,recipient2@gmail.com,recipient3@gmail.com
   ```
   
   **Multiple Recipients:**
   - **Single email**: `TO_EMAILS=user@gmail.com`
   - **Multiple emails**: `TO_EMAILS=user1@gmail.com,user2@gmail.com,user3@gmail.com`
   - **No spaces** around commas

3. **Run the application:**
   ```bash
   ruby main.rb
   ```

## 👥 Multiple Email Recipients

The application supports sending alerts to multiple email addresses:

- **Configure in `.env`**: `TO_EMAILS=email1@gmail.com,email2@gmail.com,email3@gmail.com`
- **Individual delivery**: Each recipient gets their own email
- **Error handling**: Continues sending if one email fails
- **Progress tracking**: Shows success/failure for each recipient
- **Summary report**: Displays final delivery statistics

**Example Output:**
```
📧 Preparing to send email to 3 recipient(s)
📤 Sending to: user1@gmail.com
✅ Email sent successfully to user1@gmail.com!
📤 Sending to: user2@gmail.com
✅ Email sent successfully to user2@gmail.com!
📊 Summary: 3/3 emails sent successfully
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
     - `TO_EMAILS`: Comma-separated recipient emails (e.g., `user1@gmail.com,user2@gmail.com`)

3. **Configure the schedule:**
   - Edit `.github/workflows/share-alert.yml`
   - Modify the cron expression to your preferred time
   - Current setting: `0 0 */2 * *` (every 2 days at midnight UTC)

4. **Manual trigger:**
   - Go to Actions tab in your GitHub repository
   - Select "Share Alert Cron Job" workflow
   - Click "Run workflow" to test

### Cron Schedule Examples:
```yaml
# Every 2 days at midnight UTC (current)
- cron: '0 0 */2 * *'

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
