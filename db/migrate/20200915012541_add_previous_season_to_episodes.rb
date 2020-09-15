class AddPreviousSeasonToEpisodes < ActiveRecord::Migration[6.0]
  def change
    add_column :episodes, :previous_season, :boolean, deafault: false
  end
end
