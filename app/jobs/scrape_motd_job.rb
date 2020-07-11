class ScrapeMotdJob < ApplicationJob
  queue_as :default

  def perform
    ScrapeMotdService.new.call
  end
end
