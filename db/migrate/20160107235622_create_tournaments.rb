class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :game_id
      t.string :image
      t.timestamps null: false
    end
  end
end
