class ChangeStartDateToTournaments < ActiveRecord::Migration
  def change
    change_column :tournaments, :start_date, :datetime
    change_column :tournaments, :end_date, :datetime

  end
end
