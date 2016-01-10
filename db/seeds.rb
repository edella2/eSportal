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

    # returns an array of game hashes with keys:
    # id, title, long_title, images
    HTTParty.get(@games_root + @api_key)
  end

  def fetch_tournaments_by_game(game_id)
    puts "  fetching current tournaments by game_id: #{game_id}"

    filter = "&games[]=" + game_id.to_s

    # returns an array of tournament hashes with keys:
    # id, title, start, end, city, short_title, url, description, short_description,
    #   images, links, game
    HTTParty.get(@tournaments_root + @api_key + filter)
  end

  def fetch_competitors_by_tournament(tournament_id)
    puts "    fetching competitors by tournament_id: #{tournament_id}"

    # returns an array of competitor hashes with keys:
    # id, name, country, short_name, images, race
    matches     = fetch_matches_by_tournament_id(tournament_id)
    matchups    = matches.map {|match| fetch_matchups_by_match_id(match["id"])}.flatten
    competitors = matchups.map {|matchup| get_competitors_from_matchup(matchup)}.flatten.uniq
  end

  private

  def fetch_matches_by_tournament_id(tournament_id)
    puts "      fetching matches by tournament_id: #{tournament_id}"

    filter = "&tournaments[]=" + tournament_id.to_s

    # returns an array of match hashes with keys:
    # id, title, start, end, bestOf
    HTTParty.get(@matches_root + @api_key + filter)
  end

  def fetch_matchups_by_match_id(match_id)
    puts "        fetching matchups by match_id: #{match_id}"

    filter = "&with[]=matchups"
    match  = HTTParty.get(@matches_root + "/#{match_id}" + @api_key + filter)

    # returns an array of matchup hashes with keys:
    # id, competitors
    match["matchups"]
  end

  def get_competitors_from_matchup(matchup)
    puts "          parsing competitors from match_id: #{matchup['id']}"

    # returns an array of competitor hashes with keys:
    # id, name, country, short_name, images, race
    matchup["competitors"]
  end

  # # methods below this point are not needed in current version
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

abios = Abios.new

GAMES       = abios.fetch_games

# TEMPORARY: limit number of games for which tournaments are fetched
TOURNAMENTS = [GAMES[4]].map {|game| abios.fetch_tournaments_by_game(game["id"])}.flatten

# TEMPORARY: limit the number of tournaments fetched for each game
TOURNAMENTS = TOURNAMENTS.first(4) + TOURNAMENTS.last(4)


# populates games table
GAMES.each do |game_hash|
  if game_hash
    puts "adding game to database: #{game_hash['title']}"

    Game.find_or_create_by(
      id:   game_hash["id"],
      name: game_hash["title"]
      )
  else
    puts "no game data for this record!"
  end
end

# populates tournaments, streams, and competitors tables
TOURNAMENTS.each do |tournament_hash|
  if tournament_hash
    # tournaments
    puts "adding tournament to database: #{tournament_hash['title']}"

    game = Game.find(tournament_hash["game"]["id"])

    tournament = Tournament.find_or_create_by(
      id:               tournament_hash["id"],
      name:             tournament_hash["title"],
      image:            tournament_hash["images"]["default"],
      start_date:       tournament_hash["start"],
      end_date:         tournament_hash["end"],
      thumbnail:        tournament_hash["images"]["thumbnail"],
      large:            tournament_hash["images"]["large"],
      description:      tournament_hash["description"],
      short_description:tournament_hash["short_description"],
      city:             tournament_hash["city"],
      short_title:      tournament_hash["short_title"]
      )

    game.tournaments << tournament

    # streams
    if tournament_hash['url']
      puts "  adding stream to database for tournament: #{tournament_hash['title']}"

      Stream.find_or_create_by(
        tournament_id: tournament_hash['id'],
        link:          tournament_hash['url']
        )
    else
      puts "  no stream data for #{tournament_hash['title']}!"
    end

    # competitors
    competitors = abios.fetch_competitors_by_tournament(tournament_hash["id"])

    if competitors
      puts "  adding competitors to database for tournament: #{tournament_hash['title']}"

      competitors.each do |competitor_hash|
        if competitor_hash
          puts "    adding competitor to database: #{competitor_hash['name']}"

          competitor = Competitor.find_or_create_by(
            id:   competitor_hash["id"],
            name: competitor_hash["name"]
            )

          tournament.competitors << competitor
        else
          puts "    no competitor data for this record!"
        end
      end
    else
      puts "  no competitor data for #{tournament_hash['title']}!"
    end

  else
    puts "no tournament data for this record!"
  end
end