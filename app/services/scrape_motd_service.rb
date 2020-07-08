require 'nokogiri'
require 'open-uri'

class ScrapeMotdService

  def initialize

  end

  def call
    html_content = open('https://www.bbc.co.uk/programmes/m0007fnr/episodes/guide.2013inc?nestedlevel=3').read
    doc = Nokogiri::HTML(html_content)
    past = []
    future = []
    doc.search('.episode-guide__episode').each do |element|
      date = Date.parse(element.search('.programme__titles').text.strip)
      if date > Date.today
        time = element.search('.timezone--time').text.strip
        Time.zone = 'London'
        time = Time.zone.parse(time)
        dt = Time.zone.local(date.year, date.month, date.day, time.hour, time.min, time.sec).in_time_zone
        future << dt
      else
        past << date
      end
    end

  end


end
