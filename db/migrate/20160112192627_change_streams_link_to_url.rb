class ChangeStreamsLinkToUrl < ActiveRecord::Migration
  def change
    rename_column :streams, :link, :url
  end
end
