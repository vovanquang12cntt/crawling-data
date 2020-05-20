require "mechanize"
require "pry"
require "csv"

class Crawler
  HEADER = %w(name author\ name)
  def initialize url
    @url = url
    @agent = Mechanize.new
  end

  def call
    page = @agent.get(@url)


    CSV.open("data.csv", "w") do |csv|
      csv << HEADER
      page.search("div.post-feed-item__info").each do |post|
    binding.pry

      end
    end
  end
end

Crawler.new('https://viblo.asia/newest').call