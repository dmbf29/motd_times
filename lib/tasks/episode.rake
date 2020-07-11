namespace :episode do
  desc "Scrapes MOTD websites to update all of the episodes"
  task update_all: :environment do
    ScrapeMotdJob.perform_now
  end

  desc "Scrapes Reddit to update links"
  task reddit: :environment do
    ScrapeRedditJob.perform_now
  end

  desc "Manually seed specific episodes with reddit posts"
  task manual_reddit: :environment do
    ep = Episode.find(8)
    ep.reddit_link = "https://www.reddit.com/r/footballhighlights/comments/hnrtd6/bbc_match_of_the_day_week_34_08july2020/"
    ep.save

    ep = Episode.find(34)
    ep.reddit_link = "https://www.reddit.com/r/footballhighlights/comments/hlvzab/bbc_match_of_the_day_2_week_33_show_05_july_2020/"
    ep.save

    ep = Episode.find(9)
    ep.reddit_link = "https://www.reddit.com/r/footballhighlights/comments/hlcch6/bbc_match_of_the_day_20200704/"
    ep.save

    ep = Episode.find(10)
    ep.reddit_link = "https://www.reddit.com/r/footballhighlights/comments/hk84v4/bbc_match_of_the_day_20200702/"
    ep.save

    ep = Episode.find(35)
    ep.reddit_link = "https://www.reddit.com/r/footballhighlights/comments/hhnirm/bbc_match_of_the_day_2_week_32_show_28_june_2020/"
    ep.save

    ep = Episode.find(1)
    ep.reddit_link = "https://www.reddit.com/r/footballhighlights/comments/hfvksj/bbc_match_of_the_day_week_31_25_june_2020/"
    ep.save

    ep = Episode.find(11)
    ep.reddit_link = "https://www.reddit.com/r/footballhighlights/comments/hfbmz3/bbc_match_of_the_day_week_31_show_24_june_2020/"
    ep.save

    # can't find one for MOTD2 Jun 21
    # ep = Episode.find(36)
    # ep.reddit_link = nil
    # ep.save

    ep = Episode.find(12)
    ep.reddit_link = "https://www.reddit.com/r/footballhighlights/comments/hcvl2d/bbc_match_of_the_day_week_30_show_20june2020/"
    ep.save
  end

end
