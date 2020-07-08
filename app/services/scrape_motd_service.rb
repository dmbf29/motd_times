require 'nokogiri'
require 'open-uri'

class ScrapeMotdService
  attr_reader :timezone

  def initialize(timezone)
    @timezone = timezone
  end

  def call
    # MOTD => m0007fnr / MOTD2 => m0007m8m
    motds = ['m0007fnr', 'm0007m8m']
    episodes = { past: [], future: [] }
    motds.each_with_index do |motd_id, index|
      html_content = open("https://www.bbc.co.uk/programmes/#{motd_id}/episodes/guide.2013inc?nestedlevel=3").read

      doc = Nokogiri::HTML(html_content)
      doc.search('.episode-guide__episode').each do |element|
        date = Date.parse(element.search('.programme__titles').text.strip)
        if date > Date.today
          time = element.search('.timezone--time').text.strip
          Time.zone = 'London'
          time = Time.zone.parse(time)
          dt = Time.zone.local(date.year, date.month, date.day, time.hour, time.min, time.sec).in_time_zone(timezone)
          episodes[:future] << Episode.new(time: dt, show: index + 1, past: false)
        else
          episodes[:past] << Episode.new(time: date, show: index + 1, past: true)
        end
      end
    end
    episodes
  end
end
