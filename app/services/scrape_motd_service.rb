require 'nokogiri'
require 'open-uri'

class ScrapeMotdService
  # attr_reader :timezone

  # moving timezone into controller since scraping is now background job
  # def initialize(timezone)
  #   @timezone = timezone
  # end

  def call
    # MOTD => m0007fnr / MOTD2 => m0007m8m
    motds = ['m0007fnr', 'm0007m8m']
    motds.each_with_index do |motd_id, index|
      html_content = open("https://www.bbc.co.uk/programmes/#{motd_id}/episodes/guide.2013inc?nestedlevel=3").read

      doc = Nokogiri::HTML(html_content)
      doc.search('.episode-guide__episode').each do |element|
        date = Date.parse(element.search('.programme__titles').text.strip)
        episode = Episode.find_by(date: date)

        # if the episode has aired but hasn't been changed in DB
        episode.set_in_past! if episode.time&.past? && !episode.past


        if episode
          # update?
        else
          # create episode
        end


        if date >= Date.today
          time = element.search('.timezone--time').text.strip
          Time.zone = 'London'
          time = Time.zone.parse(time)
          dt = Time.zone.local(date.year, date.month, date.day, time.hour, time.min, time.sec).utc
          # dt = Time.zone.local(date.year, date.month, date.day, time.hour, time.min, time.sec)
          Episode.create(time: dt, show: index + 1, past: false)
        else
          Episode.create(time: nil, show: index + 1, past: true)
        end
      end
    end
  end
end
