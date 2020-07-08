class PagesController < ApplicationController
  def home
    timezone_name = params[:timezone]&.split('0) ')&.last || 'London'
    @timezone = ActiveSupport::TimeZone.all.find { |tz| tz.name == timezone_name }
    episodes = ScrapeMotdService.new(@timezone).call
    @future = episodes[:future]
    @past = episodes[:past]
  end
end
