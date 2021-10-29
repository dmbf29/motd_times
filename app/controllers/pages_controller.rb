class PagesController < ApplicationController
  def home
    # Scraping moved to a background job
    @time_zones = ActiveSupport::TimeZone.all.sort
    timezone_name = params[:timezone]&.split('0) ')&.last || cookies[:timezone] || 'London'
    @timezone = ActiveSupport::TimeZone.all.find { |tz| tz.name == timezone_name }
    # @future = Episode.where(past: false).where.not(previous_season: true).order(:date)
    @future = Episode.where("time > ?", Date.today).where.not(previous_season: true).order(:date)
    @past = Episode.where("time <= ?", Date.today).where.not(reddit_link: nil, previous_season: true).order(date: :desc)
    @previous = Episode.where(previous_season: true).where.not(reddit_link: nil).order(date: :desc)
    cookies[:timezone] = timezone_name
  end
end

# client = HTTParty.get('https://www.reddit.com/r/footballhighlights.json')
# client['data']['children'].each do |post|
#   puts post['data']['title']
# end
