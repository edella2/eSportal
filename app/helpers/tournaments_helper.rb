module TournamentsHelper
  def list_competitor_names_for(tournament)
    tournament.competitors.any? ? tournament.competitors.map {|c| c.name} : ["Competitor list soon"]
  end

  # def list_stream_urls_for(tournament)
  #   tournament.streams.any? ? tournament.streams.map {|s| s.link} : ["Stream list soon"]
  # end
end
