class RemoveTournamentIdFromCompetitors < ActiveRecord::Migration
  def change
    remove_column :competitors, :tournament_id
  end
end
