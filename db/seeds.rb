# #############################################################################
# build seed data from backups on development only
# #############################################################################

# if Rails.env.development?
  games_backup_path       = File.expand_path('.' + '/db/api_response_backups/games_backup.json')
  tournaments_backup_path = File.expand_path('.' + '/db/api_response_backups/tournaments_backup.json')
  matches_backup_path     = File.expand_path('.' + '/db/api_response_backups/matches_backup.json')
  matchups_backup_path    = File.expand_path('.' + '/db/api_response_backups/matchups_backup.json')
  competitors_backup_path = File.expand_path('.' + '/db/api_response_backups/competitors_backup.json')

  GAMES       = []
  TOURNAMENTS = []
  MATCHES     = []
  MATCHUPS    = []

  puts "parsing game data from #{games_backup_path}"
  File.open(games_backup_path).each do |line|
    GAMES << JSON.parse(line)
  end

  puts "parsing tournament data from #{tournaments_backup_path}"
  File.open(tournaments_backup_path).each do |line|
    TOURNAMENTS << JSON.parse(line)
  end

  puts "parsing match data from #{matches_backup_path}"
  File.open(matches_backup_path).each do |line|
    MATCHES << JSON.parse(line)
  end

  puts "parsing matchup data from #{matches_backup_path}"
  File.open(matchups_backup_path).each do |line|
    MATCHUPS << JSON.parse(line)
  end
# end

# #############################################################################
# build seed data directly from API
# #############################################################################

# if Rails.env.production?
#   GAMES       = Abios.fetch_games
#   # temporary limit on games (must be an array)
#   # GAMES = [GAMES[4]]

#   TOURNAMENTS = GAMES.map {|game| Abios.fetch_tournaments_by_game_id(game_id: game['id'])}.flatten
#   # temporary limit on tournaments (must be an array)
#   # TOURNAMENTS = TOURNAMENTS.first(8)

#   MATCHES     = TOURNAMENTS.map {|tourn| Abios.fetch_matches_by_tournament_id(tournament_id: tourn['id'])}.flatten
#   # temporary limit on matches (must be an array)
#   # MATCHES = MATCHES.first(4)

#   MATCHUPS    = MATCHES.map {|match| Abios.fetch_matchups_by_match_id(match_id: match['id'])}.flatten
#   # temporary limit on matchups (must be an array)
#   # MATCHUPS = MATCHUPS.first(3)
# end

# #############################################################################
# populate db (same for production and deployment)
# #############################################################################

class SeedBuilder
  def initialize(games: GAMES, tournaments: TOURNAMENTS)
    populate_games(games)
    populate_tournaments(tournaments)
  end

  # populate games
  def populate_games(array_of_game_objs)
    array_of_game_objs.each do |game_hash|
      if game_hash
        puts "adding game to database: #{game_hash['title']}"

        Game.find_or_create_by(
          id:               game_hash["id"],
          title:            game_hash["title"],
          long_title:       game_hash["long_title"],
          image_square:     game_hash["images"]["square"],
          image_circle:     game_hash["images"]["circle"],
          image_rectangle:  game_hash["images"]["rectangle"]
          )
      else
        puts "no game data for this record!"
      end
    end
  end

  # populate tournaments and call methods to populate streams/competitors and build game-tourn association
  def populate_tournaments(array_of_tourn_objects)
    array_of_tourn_objects.each do |tournament_hash|
      if tournament_hash
        # tournaments
        puts "  adding tournament to database: #{tournament_hash['title']}"

        tournament = Tournament.find_or_create_by(
          id:                tournament_hash["id"],
          title:             tournament_hash["title"],
          short_title:       tournament_hash["short_title"],
          start:             tournament_hash["start"],
          end:               tournament_hash["end"],
          city:              tournament_hash["city"],
          description:       tournament_hash["description"],
          short_description: tournament_hash["short_description"],
          url:               tournament_hash["url"],
          image_default:     tournament_hash["images"]["default"],
          image_large:       tournament_hash["images"]["large"],
          image_thumbnail:   tournament_hash["images"]["thumbnail"],
          prizepool_total:   tournament_hash["prizepool"]["total"],
          prizepool_first:   tournament_hash["prizepool"]["first"],
          prizepool_second:  tournament_hash["prizepool"]["second"],
          prizepool_third:   tournament_hash["prizepool"]["third"],
          link_website:      tournament_hash["links"]["website"],
          link_wiki:         tournament_hash["links"]["wiki"],
          link_youtube:      tournament_hash["links"]["youtube"]
          )

        game = Game.find(tournament_hash["game"]["id"])
        game.tournaments << tournament

        populate_streams(tournament_hash)
        populate_competitors(tournament_hash)
      else
        puts "  no tournament data for this record!"
      end
    end
  end

  private

  # populate streams (called from #populate_tournaments)
  def populate_streams(tournament_hash)
    if tournament_hash['url']
      puts "    adding stream to database for tournament: #{tournament_hash['title']}"

      Stream.find_or_create_by(
        tournament_id: tournament_hash["id"],
        url:           tournament_hash["url"]
        )
    else
      puts "    no stream data for #{tournament_hash['title']}!"
    end
  end

  # populate competitors (called from #populate_tournaments)
  def populate_competitors(tournament_hash)
    competitors = get_competitors_from_tournament(tournament_hash)

    competitors.each do |competitor_hash|
      if competitor_hash
        puts "    adding competitor to database: #{competitor_hash['name']}"

        # check for null values in country field
        country_name            = competitor_hash["country"] ? competitor_hash["country"]["name"] : competitor_hash["country"]
        country_short_name      = competitor_hash["country"] ? competitor_hash["country"]["short_name"] : competitor_hash["country"]
        country_image_default   = competitor_hash["country"] ? competitor_hash["country"]["images"]["default"] : competitor_hash["country"]
        country_image_thumbnail = competitor_hash["country"] ? competitor_hash["country"]["images"]["thumbnail"] : competitor_hash["country"]

        competitor = Competitor.find_or_create_by(
          id:                      competitor_hash["id"],
          name:                    competitor_hash["name"],
          country_name:            country_name,
          country_short_name:      country_short_name,
          country_image_default:   country_image_default,
          country_image_thumbnail: country_image_thumbnail,
          # competitor_hash["race"] contains a collection of images instead of a race name
          # race:                    competitor_hash["race"],
          )

        tournament = Tournament.find(tournament_hash["id"])
        tournament.competitors << competitor
      else
        puts "    no competitor data for this record!"
      end
    end
  end

  # utility method for linking competitors and tournaments across intermediate relations
  def get_competitors_from_tournament(tournament_hash)
    match_ids = MATCHES.select {|m| m["tournament_id"] == tournament_hash["id"]}.map {|m| m["id"]}
    matchups  = MATCHUPS.select {|m| match_ids.include? m["match_id"] }
    # binding.pry
    matchups.map {|m| m["competitors"]}.flatten.uniq
  end
end

SeedBuilder.new