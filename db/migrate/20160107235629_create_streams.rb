class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.string :title
      t.string :link
      t.integer :tournament_id
      t.string :language

      t.timestamps null: false
    end
  end
end
