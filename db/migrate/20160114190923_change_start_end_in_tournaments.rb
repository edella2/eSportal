class ChangeStartEndInTournaments < ActiveRecord::Migration
  def change
    rename_column :tournaments, :start, :start_time
    rename_column :tournaments, :end,   :end_time
  end
end
