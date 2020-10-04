require 'nokogiri'
require 'open-uri'

class ScrapeMotdService
  # moved timezone into controller since scraping is now background job

  def call
    # MOTD => m0007fnr / MOTD2 => m0007m8m / Season '19-'20
    # MOTD => m000m7x5 / MOTD2 => m000mn4w
    motds = ['m000m7x5', 'm000mn4w']
    motds.each_with_index do |motd_id, index|
      html_content = open("https://www.bbc.co.uk/programmes/#{motd_id}/episodes/guide.2013inc?nestedlevel=3").read


      doc = Nokogiri::HTML(html_content)
      doc.search('.episode-guide__episode').each do |element|
        next unless element.search('.programme__titles').text.strip =~ /\A\d/

        date = Date.parse(element.search('.programme__titles').text.strip)
        episode = Episode.find_by(date: date)

        Time.zone = 'London'
        if episode
          puts "Episode ID: #{episode.id} | found an episode with date: #{date}"
          puts "Episode past? #{episode.past?}"
          puts "Episode show? #{episode.show?}"
          # if the episode has aired but hasn't been changed in DB
          episode.set_in_past! if episode.time&.past? && !episode.past

          # update time
          time = element.search('.timezone--time').text.strip
          next if time.blank?

          time = Time.zone.parse(time)
          dt = Time.zone.local(date.year, date.month, date.day, time.hour, time.min, time.sec)
          episode.update(time: dt) unless dt == episode.time
        else
          puts "creating a new episode with date: #{date}"
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
