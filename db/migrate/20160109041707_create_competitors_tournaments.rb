class CreateCompetitorsTournaments < ActiveRecord::Migration
  def change
    create_table :competitors_tournaments do |t|
      t.integer :competitor_id
      t.integer :tournament_id
    end
  end
end
