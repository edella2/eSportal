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
    filter = "&tournaments[]=" + tournament_id.to_s
    HTTParty.get(@competitors_root + @api_key + filter)
  end

  def get_stream_by_tournament(tournament_id)
    puts "fetching stream by tournament_id: #{tournament_id}"
    HTTParty.get(@tournaments_root + "/" + tournament_id.to_s + @api_key).fetch("url")
  end

  def get_tournaments_by_game(game_id)
    puts "fetching tournaments by game_id: #{game_id}"
    filter = "&games[]=" + game_id.to_s
    HTTParty.get(@tournaments_root + @api_key + filter)
  end

  private

  def get_matches
    puts "fetching matches"
    HTTParty.get(@matches_root + @api_key)
  end

  def get_matches_by_tournament(tournament_id)
    puts "fetching matches by tournament_id: #{tournament_id}"
    filter = "&tournaments[]=" + tournament_id.to_s
    HTTParty.get(@matches_root + @api_key + filter)
  end
end

a = Abios.new

GAMES       = a.get_games

# get only counterstrike tournaments
TOURNAMENTS = [GAMES[4]].map       {|game| a.get_tournaments_by_game(game["id"])}.flatten

# throttle the number of tournaments returned
TOURNAMENTS = TOURNAMENTS.first(10)

COMPETITORS = TOURNAMENTS.map {|tournament| a.get_competitors_by_tournament(tournament["id"])}.flatten
STREAMS     = TOURNAMENTS.map {|tournament| a.get_stream_by_tournament(tournament["id"])}

GAMES.each do |game|
  puts "Adding #{game["title"]} to database"

  Game.find_or_create_by(
    id:   game["id"],
    name: game["title"]
    )
end

TOURNAMENTS.each_with_index do |tournament, index|
  puts "Adding #{tournament['title']} to database"

  Tournament.find_or_create_by(
    id:         tournament["id"],
    name:       tournament["title"],
    image:      tournament["images"]["default"],
    start_date: tournament["start"],
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
  print "."

  if competitor
    puts "Adding #{competitor['name']} to database"

    Competitor.find_or_create_by(
      id:   competitor["id"],
      name: competitor["name"]
      )
  end
end

