namespace :episode do
  desc "Scrapes MOTD websites to update all of the episodes"
  task update_all: :environment do
    ScrapeMotdJob.perform_now
  end

end
