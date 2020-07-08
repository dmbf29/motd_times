class PagesController < ApplicationController
  def home
    timezone_name = params[:timezone]&.split('0) ')&.last || cookies[:timezone] || 'London'
    @timezone = ActiveSupport::TimeZone.all.find { |tz| tz.name == timezone_name }
    episodes = ScrapeMotdService.new(@timezone).call
    @future = episodes[:future]
    @past = episodes[:past]
    cookies[:timezone] = timezone_name
  end
end
