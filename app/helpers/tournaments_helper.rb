module TournamentsHelper

  def is_live(tournament)
    tournament.start_date <= DateTime.now && tournament.end_date >= DateTime.now
  end

end
