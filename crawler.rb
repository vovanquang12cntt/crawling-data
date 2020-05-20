require "mechanize"
require "pry"
require "csv"

class CrawlerService
  HEADER = %w(Author\ name Title Url)
  BASE_PAGINATE_URL = "/newest?page="
  URL = "https://viblo.asia/newest"

  def initialize
    @agent = Mechanize.new
    @page_number = 1
  end

  def perfom
    page = @agent.get URL

    puts "------------------"
    puts "Crawling.........."

    CSV.open("data.csv", "w", encoding: "UTF-8") do |csv|
      csv << HEADER

      while true
        page.search("div.post-feed-item__info").each do |post|
          author_name = post.search("a.mr-05").text.strip
          title = post.search("h3.word-break").last.text
          url = post.search("a.link").last.attributes["href"].value

          csv << [
            author_name,
            title,
            url
          ]
        end

        @page_number += 1
        next_page = page.link_with(href: BASE_PAGINATE_URL + @page_number.to_s)

        break if @page_number > 3

        page = next_page.click
      end
    end

    puts "------------------"
    puts "Crawling finished."
  end
end

CrawlerService.new.perfom