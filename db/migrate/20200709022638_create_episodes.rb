class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.datetime :time
      t.date :date
      t.integer :show
      t.boolean :past
      t.string :reddit_link
      t.string :motd_link

      t.timestamps
    end

    motds = ['m0007fnr', 'm0007m8m']
    motds.each_with_index do |motd_id, index|
      html_content = open("https://www.bbc.co.uk/programmes/#{motd_id}/episodes/guide.2013inc?nestedlevel=3").read

      doc = Nokogiri::HTML(html_content)
      doc.search('.episode-guide__episode').each do |element|
        date = Date.parse(element.search('.programme__titles').text.strip)
        if date >= Date.today
          time = element.search('.timezone--time').text.strip
          Time.zone = 'London'
          time = Time.zone.parse(time)
          dt = Time.zone.local(date.year, date.month, date.day, time.hour, time.min, time.sec)
          # dt = Time.zone.local(date.year, date.month, date.day, time.hour, time.min, time.sec)
          Episode.create(time: dt, show: index + 1, past: false, date: date)
        else
          Episode.create(time: nil, show: index + 1, past: true, date: date)
        end
      end
    end
  end
end
