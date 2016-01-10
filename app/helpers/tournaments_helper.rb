module TournamentsHelper

  def is_live(tournament)
    dates = (tournament.start_date..tournament.end_date).to_a
    dates.include?(DateTime.now.to_date)
  end
end
