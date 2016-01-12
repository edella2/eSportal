class AddColsToCompetitors < ActiveRecord::Migration
  def change
    add_column :competitors, :country_name, :string
    add_column :competitors, :country_short_name, :string
    add_column :competitors, :country_image_default, :string
    add_column :competitors, :country_image_thumbnail, :string
    add_column :competitors, :race, :string
  end
end
