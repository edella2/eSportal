class RemoveGameIdFromTournaments < ActiveRecord::Migration
  def change
    remove_column :tournaments, :game_id
  end
end
