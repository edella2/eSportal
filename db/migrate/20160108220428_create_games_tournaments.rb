class CreateGamesTournaments < ActiveRecord::Migration
  def change
    create_table :games_tournaments do |t|
      t.integer :game_id
      t.integer :tournament_id
    end
  end
end
