class AddColsToTournaments < ActiveRecord::Migration
  def change
    rename_column :tournaments, :name, :title
    rename_column :tournaments, :start_date, :start
    rename_column :tournaments, :end_date, :end
    rename_column :tournaments, :large, :image_large
    rename_column :tournaments, :thumbnail, :image_thumbnail
    add_column    :tournaments, :image_default, :string
    add_column    :tournaments, :prizepool_total, :string
    add_column    :tournaments, :prizepool_first, :string
    add_column    :tournaments, :prizepool_second, :string
    add_column    :tournaments, :prizepool_third, :string
    add_column    :tournaments, :link_website, :string
    add_column    :tournaments, :link_wiki, :string
    add_column    :tournaments, :link_youtube, :string
  end
end
