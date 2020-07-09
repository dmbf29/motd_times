require 'nokogiri'
require 'open-uri'

class ScrapeMotdService
  # moved timezone into controller since scraping is now background job

  def call
    # MOTD => m0007fnr / MOTD2 => m0007m8m
    motds = ['m0007fnr', 'm0007m8m']
    motds.each_with_index do |motd_id, index|
      html_content = open("https://www.bbc.co.uk/programmes/#{motd_id}/episodes/guide.2013inc?nestedlevel=3").read

      doc = Nokogiri::HTML(html_content)
      doc.search('.episode-guide__episode').each do |element|
        date = Date.parse(element.search('.programme__titles').text.strip)
        episode = Episode.find_by(date: date)

        Time.zone = 'London'
        if episode
          puts "found an episode with date: #{date}"
          # if the episode has aired but hasn't been changed in DB
          episode.set_in_past! if episode.time&.past? && !episode.past

          # update time
          time = element.search('.timezone--time').text.strip
          next if time.blank?

          time = Time.zone.parse(time)
          dt = Time.zone.local(date.year, date.month, date.day, time.hour, time.min, time.sec)
          episode.update(time: dt) unless dt == episode.time
        else
          # create episode
          time = element.search('.timezone--time').text.strip
          dt = nil
          unless time.blank?
            time = Time.zone.parse(time)
            dt = Time.zone.local(date.year, date.month, date.day, time.hour, time.min, time.sec)
          end
          Episode.create(time: dt, show: index + 1, past: date <= Date.today, date: date)
        end
      end
    end
  end
end
