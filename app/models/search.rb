class Search
  def initialize(query)
    @query = query
  end

  # does not return competitor matches since we have limited data on competitors for show pages
  def matches
    get_matching_tournaments + get_tournaments_of_matching_competitors
  end

  private

  def get_matching_tournaments
    tournament_matches = Tournament.where("LOWER(title) LIKE ?", "%#{@query.downcase}%")
    tournament_matches + Tournament.where("LOWER(short_title) LIKE ?", "%#{@query.downcase}%")
  end

  def get_matching_competitors
    Competitor.where("LOWER(name) LIKE ?", "%#{@query.downcase}%")
  end

  def get_tournaments_of_matching_competitors
    competitors = get_matching_competitors
    competitors.map {|competitor| competitor.tournaments}.flatten.uniq
  end
end