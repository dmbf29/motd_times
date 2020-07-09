class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.datetime :time
      t.integer :show
      t.boolean :past
      t.string :reddit_link
      t.string :motd_link

      t.timestamps
    end
  end
end
