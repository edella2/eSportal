class AddColsToGames < ActiveRecord::Migration
  def change
    rename_column :games, :name, :title
    add_column    :games, :long_title, :string
    add_column    :games, :image_square, :string
    add_column    :games, :image_circle, :string
    add_column    :games, :image_rectangle, :string
  end
end
