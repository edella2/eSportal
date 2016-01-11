games_backup_path       = File.expand_path('.' + '/db/api_response_backups/games_backup.json')
tournaments_backup_path = File.expand_path('.' + '/db/api_response_backups/tournaments_backup.json')
matches_backup_path     = File.expand_path('.' + '/db/api_response_backups/matches_backup.json')
matchups_backup_path    = File.expand_path('.' + '/db/api_response_backups/matchups_backup.json')

games       = []
tournaments = []
matches     = []
matchups    = []

puts "parsing game data from #{games_backup_path}"
File.open(games_backup_path).each do |line|
  games << JSON.parse(line)
end

puts "parsing tournament data from #{tournaments_backup_path}"
File.open(tournaments_backup_path).each do |line|
  tournaments << JSON.parse(line)
end

puts "parsing match data from #{matches_backup_path}"
File.open(matches_backup_path).each do |line|
  matches << JSON.parse(line)
end

puts "parsing matchup data from #{matches_backup_path}"
File.open(matchups_backup_path).each do |line|
  matchups << JSON.parse(line)
end

# populates games table
games.each do |game_hash|
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
tournaments.each do |tournament_hash|
  if tournament_hash
    # tournaments
    puts "adding tournament to database: #{tournament_hash['title']}"

    game = Game.find(tournament_hash["game"]["id"])

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
    competitors = Abios.fetch_competitors_by_tournament(tournament_hash["id"])

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