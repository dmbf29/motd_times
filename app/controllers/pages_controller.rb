class PagesController < ApplicationController
  def home
    # TODO: have JS make a request to app and not scrape again
    @time_zones = ActiveSupport::TimeZone.all.sort
    timezone_name = params[:timezone]&.split('0) ')&.last || cookies[:timezone] || 'London'
    @timezone = ActiveSupport::TimeZone.all.find { |tz| tz.name == timezone_name }
    episodes = ScrapeMotdService.new(@timezone).call
    @future = episodes[:future].sort_by { |ep| ep.time }
    @past = episodes[:past].sort_by { |ep| ep.time }.reverse
    cookies[:timezone] = timezone_name
  end
end
