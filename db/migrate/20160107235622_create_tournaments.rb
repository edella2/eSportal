class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :game_id
      t.string :image
      t.string :thumbnail
      t.string :large
      t.string :description
      t.string :short_description
      t.string :city
      t.string :short_title

      t.timestamps null: false
    end
  end
end
