class RemoveImageFromTournaments < ActiveRecord::Migration
  def change
    remove_column :tournaments, :image
  end
end
