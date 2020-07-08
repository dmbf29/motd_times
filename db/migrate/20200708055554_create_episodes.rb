class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.time :date
      t.integer :show

      t.timestamps
    end
  end
end
