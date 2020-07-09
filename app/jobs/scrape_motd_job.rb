class ScrapeMotdJob < ApplicationJob
  queue_as :default

  def perform
    # update past/present
    ScrapeMotdService.new.call
    # get reddit/motd links
  end
end
