require 'httparty'
require 'nokogiri'
require_relative 'smtp'

class ShareSansarScraper
  BASE_URL = 'https://www.sharesansar.com'

  def fetch_open_ipos
    puts "Fetching IPO data from #{BASE_URL}/investment"
    url = "#{BASE_URL}/investment"

    begin
      response = HTTParty.get(url, timeout: 30)

      if response.code != 200
        puts "HTTP Error: #{response.code} - #{response.message}"
        return []
      end

      doc = Nokogiri::HTML(response.body)

      table = doc.at('table')
      unless table
        puts 'No table found on the page'
        puts "Page content sample: #{doc.text[0..200]}..."
        return []
      end

      headers = table.xpath('.//thead//th').map { |th| th.text.strip }
      rows = table.xpath('.//tbody//tr')

      puts "Table headers found: #{headers.inspect}"

      ipos = rows.map do |row|
        cells = row.xpath('td').map { |td| td.text.strip }
        next if cells.empty?

        Hash[headers.zip(cells)]
      end.compact

      puts "Found #{ipos.length} IPO entries"
      puts "Sample IPO data: #{ipos.first.inspect}" if ipos.any?
      ipos
    rescue StandardError => e
      puts "Error fetching IPO data: #{e.message}"
      puts "Error backtrace: #{e.backtrace.first(3)}"
      []
    end
  end
end
