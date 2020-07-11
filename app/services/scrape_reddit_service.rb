class ScrapeRedditService
  attr_reader :url

  def initialize
    @url = 'https://www.reddit.com/r/footballhighlights.json'
  end

  def call
    # until not too many requests
    response = HTTParty.get(url, headers: { 'User-agent': 'motd-times' })
    p response
    p response['data']
    return unless response['data']

    posts = response['data']['children']
    motds = posts.select { |post| post['data']['title'] =~ (/BBC/) }
    puts "Found these episodes:"
    motds.each do |motd|
      puts motd['data']['title']
      date = Date.parse(motd['data']['title'])
      episode = Episode.find_by(date: date)
      next unless episode && episode.reddit_link.nil?

      episode.reddit_link = motd['data']['url']
      episode.save
      puts "Updated with: #{motd['data']['url']}"
    end
  end
end
