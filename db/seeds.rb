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
      id:         tournament_hash["id"],
      name:       tournament_hash["title"],
      image:      tournament_hash["images"]["default"],
      start_date: tournament_hash["start"],
      end_date:   tournament_hash["end"]
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