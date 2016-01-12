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

def get_competitors_from_tournament_hash(tournament_id)
  match_ids = MATCHES.select {|m| m['tournament_id'] == tournament_id}.map {|m| m['id']}
  matchups  = MATCHUPS.select {|m| match_ids.include? m['match_id'] }

  matchups.map {|m| m['competitors']}.flatten.uniq
end

# populate games table
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

# populate tournaments, streams, and competitors tables
TOURNAMENTS.each do |tournament_hash|
  if tournament_hash
    # tournaments
    puts "adding tournament to database: #{tournament_hash['title']}"

    tournament = Tournament.find_or_create_by(
      id:                tournament_hash["id"],
      name:              tournament_hash["title"],
      image:             tournament_hash["images"]["default"],
      start_date:        tournament_hash["start"],
      end_date:          tournament_hash["end"],
      thumbnail:         tournament_hash["images"]["thumbnail"],
      large:             tournament_hash["images"]["large"],
      description:       tournament_hash["description"],
      short_description: tournament_hash["short_description"],
      city:              tournament_hash["city"],
      short_title:       tournament_hash["short_title"]
      )

    game = Game.find(tournament_hash["game"]["id"])

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
    competitors = get_competitors_from_tournament_hash(tournament_hash['id'])

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