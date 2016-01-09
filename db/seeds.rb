class Abios
  def initialize
    @api_key          = "?access_token=#{ENV['ABIOS_API_KEY']}"
    @games_root       = "https://api.abiosgaming.com/v1/games"
    @matches_root     = "https://api.abiosgaming.com/v1/matches"
    @competitors_root = "https://api.abiosgaming.com/v1/competitors"
    @tournaments_root = "https://api.abiosgaming.com/v1/tournaments"
  end

  def get_games
    puts "fetching all games"

    HTTParty.get(@games_root + @api_key)
  end

  def get_tournaments
    puts "fetching all tournaments"

    HTTParty.get(@tournaments_root + @api_key)
  end

  def get_matches_by_tournament
  end

  def get_competitors
    # TODO
  end

  def get_competitors_by_tournament(tournament_id)
    puts "fetching competitors by tournament_id: #{tournament_id}"

    matches = get_matches_by_tournament(tournament_id)
    matches.map {|match| get_competitors_by_match(match["id"], tournament_id)}
  end

  def get_stream_by_tournament(tournament_id)
    puts "fetching stream by tournament_id: #{tournament_id}"

    HTTParty.get(@tournaments_root + "/#{tournament_id.to_s}" + @api_key).fetch("url")
  end

  def get_tournaments_by_game(game_id)
    puts "fetching tournaments by game_id: #{game_id}"

    filter = "&games[]=" + game_id.to_s
    HTTParty.get(@tournaments_root + @api_key + filter)
  end

  def get_matches
    puts "fetching matches"

    HTTParty.get(@matches_root + @api_key)
  end

  def get_matches_by_tournament(tournament_id)
    puts "fetching matches by tournament_id: #{tournament_id}"

    filter = "&tournaments[]=" + tournament_id.to_s
    HTTParty.get(@matches_root + @api_key + filter)
  end

  def get_competitors_by_match(match_id, tournament_id)
    puts "fetching competitors by match_id: #{match_id}"

    filter = "&with[]=matchups"
    match = HTTParty.get(@matches_root + "/#{match_id}" + @api_key + filter)
    matchups = match["matchups"]
    matchups = matchups.map {|matchup| matchup["competitors"]}.flatten
    matchups.each {|matchup| matchup["tournament_id"] = tournament_id if matchup}
  end
end

a = Abios.new

GAMES       = a.get_games

# TEMPORARY: get only counterstrike tournaments
TOURNAMENTS = [GAMES[4]].map       {|game| a.get_tournaments_by_game(game["id"])}.flatten

# TEMPORARY: throttle the number of tournaments returned
TOURNAMENTS = TOURNAMENTS.first(8)

COMPETITORS = TOURNAMENTS.map {|tournament| a.get_competitors_by_tournament(tournament["id"])}.flatten
STREAMS     = TOURNAMENTS.map {|tournament| a.get_stream_by_tournament(tournament["id"])}


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
    start_time: tournament["start"],
    end_date:   tournament["end"],
    game_id:    tournament["game"]["id"]
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
      tournament.competitors.find_or_create_by(id: competitor["id"], name: competitor["name"])
    rescue
      next
    end
  end
end
