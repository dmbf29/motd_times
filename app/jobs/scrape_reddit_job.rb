class ScrapeRedditJob < ApplicationJob
  queue_as :default

  def perform
    ScrapeRedditService.new.call
  end
end
