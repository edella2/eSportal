class Abios
  def initialize
    @games_root       = "https://api.abiosgaming.com/v1/games"
    @matches_root     = "https://api.abiosgaming.com/v1/matches"
    @competitors_root = "https://api.abiosgaming.com/v1/competitors"
    @tournaments_root = "https://api.abiosgaming.com/v1/tournaments"

    @api_key          = "?access_token=#{ENV['ABIOS_API_KEY']}"
  end

  def fetch_games
    puts "fetching all games"

    HTTParty.get(@games_root + @api_key)
  end

  def fetch_tournaments_by_game(game_id)
    puts "  fetching current tournaments by game_id: #{game_id}"

    filter = "&games[]=" + game_id.to_s
    HTTParty.get(@tournaments_root + @api_key + filter)
  end

  def fetch_matches_by_tournament_id(tournament_id)
    puts "      fetching matches by tournament_id: #{tournament_id}"

    filter = "&tournaments[]=" + tournament_id.to_s

    # returns an array of match hashes with keys: id, title, start, end, bestOf
    HTTParty.get(@matches_root + @api_key + filter)
  end

  def fetch_matchups_by_match_id(match_id)
    puts "        fetching matchups by match_id: #{match_id}"

    filter = "&with[]=matchups"

    match = HTTParty.get(@matches_root + "/#{match_id}" + @api_key + filter)

    # returns an array of matchups with keys: id, competitors
    match["matchups"]
  end

  def get_competitors_from_matchup(matchup)
    puts "          parsing competitors from match_id: #{matchup['id']}"

    # returns an array of competitors with keys: id, name, country, short_name, images, race
    matchup["competitors"]
  end

  def fetch_competitors_by_tournament(tournament_id)
    puts "    fetching competitors by tournament_id: #{tournament_id}"

    matches     = fetch_matches_by_tournament_id(tournament_id)
    matchups    = matches.map {|match| fetch_matchups_by_match_id(match["id"])}.flatten
    competitors = matchups.map {|matchup| get_competitors_from_matchup(matchup)}.flatten
  end

  # # methods below this point are needed in current version
  # # ***************************************************************************

  # # don't use if tournaments already fetched
  # def fetch_stream_by_tournament(tournament_id)
  #   puts "fetching stream by tournament_id: #{tournament_id}"

  #   HTTParty.get(@tournaments_root + "/#{tournament_id.to_s}" + @api_key).fetch("url")
  # end

  # def fetch_matches
  #   puts "fetching current matches"

  #   HTTParty.get(@matches_root + @api_key)
  # end

  # def fetch_tournaments_by_game(game_id)
  #   puts "fetching tournaments by game_id: #{game_id}"

  #   filter = "&games[]=" + game_id.to_s
  #   HTTParty.get(@tournaments_root + @api_key + filter)
  # end

  # def fetch_tournaments_with_matches_by_game(game_id)
  #   puts "fetching tournaments by game_id: #{game_id}"

  #   filter = "&with[]=matches&game[]=#{game_id}"
  #   HTTParty.get(@tournaments_root + @api_key + filter)
  # end

  # def fetch_matches_with_competitors
  # end

  # def fetch_tournaments
  #   puts "fetching current tournaments"

  #   HTTParty.get(@tournaments_root + @api_key)
  # end
end

a = Abios.new

GAMES       = a.fetch_games

# TEMPORARY: get only counterstrike tournaments
TOURNAMENTS = [GAMES[4]].map {|game| a.fetch_tournaments_by_game(game["id"])}.flatten

# TEMPORARY: limit the number of tournaments fetched
TOURNAMENTS = TOURNAMENTS.first(8)

COMPETITORS = TOURNAMENTS.map {|tournament| a.fetch_competitors_by_tournament(tournament["id"])}.flatten
STREAMS     = TOURNAMENTS.map {|tournament| tournament["url"]}

binding.pry

GAMES.each do |game|
  puts "Adding #{game["title"]} to database"

  Game.find_or_create_by(
    id:   game["id"],
    name: game["title"]
    )
end

TOURNAMENTS.each do |tournament|
  puts "Adding #{tournament['title']} to database"

  Tournament.find_or_create_by(
    id:         tournament["id"],
    name:       tournament["title"],
    image:      tournament["images"]["default"],
    start_date: tournament["start"],
    end_date:   tournament["end"]
    )

  puts "Adding #{tournament['title']}'s stream to database"

  Stream.find_or_create_by(
    tournament_id: tournament['id'],
    link:          tournament['url']
    )
end

COMPETITORS.each do |competitor|
  if competitor
    puts "Adding #{competitor['name']} to database"

    begin
      tournament = Tournament.find(competitor["tournament_id"])
      tournament.competitors.find_or_create_by(
        id:   competitor["id"],
        name: competitor["name"]
        )
    rescue
      next
    end
  end
end