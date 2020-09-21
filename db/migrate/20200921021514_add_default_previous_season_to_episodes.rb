class AddDefaultPreviousSeasonToEpisodes < ActiveRecord::Migration[6.0]
  def change
    change_column_default :episodes, :previous_season, from: nil, to: false
    Episode.where(previous_season: nil).each do |ep|
      ep.previous_season = false
      ep.save
    end
  end
end
