class CreateTeamsTournaments < ActiveRecord::Migration
  def change
    create_table :teams_tournaments do |t|
      t.integer :tournament_id
      t.integer :team_id
    end
  end
end
