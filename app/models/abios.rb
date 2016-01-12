# this class facilitates interaction with the Abios API from within the controllers
module Abios
  @@games_root       = "https://api.abiosgaming.com/v1/games"
  @@matches_root     = "https://api.abiosgaming.com/v1/matches"
  @@competitors_root = "https://api.abiosgaming.com/v1/competitors"
  @@tournaments_root = "https://api.abiosgaming.com/v1/tournaments"
  @@api_key          = "?access_token=#{ENV['ABIOS_API_KEY']}"

  def self.fetch_games(api_key: @@api_key)
    puts "fetching all games"

    # returns an array of game hashes with keys:
    # id, title, long_title, images
    HTTParty.get(@@games_root + api_key)
  end

  def self.fetch_tournaments_by_game_id(game_id: 5, api_key: @@api_key)
    puts "  fetching current tournaments by game_id: #{game_id}"

    filter = "&games[]=" + game_id.to_s

    # returns an array of tournament hashes with keys:
    # id, title, start, end, city, short_title, url, description, short_description,
    #   images, links, game
    tournaments = HTTParty.get(@@tournaments_root + api_key + filter)
  end

  def self.fetch_competitors_by_tournament(tournament_id: 899, api_key: @@api_key)
    puts "    fetching competitors by tournament_id: #{tournament_id}"

    matches     = fetch_matches_by_tournament_id(tournament_id)
    matchups    = matches.map {|match| fetch_matchups_by_match_id(match["id"])}.flatten

    # returns an array of competitor hashes with keys:
    # id, name, country, short_name, images, race
    matchups.map {|matchup| get_competitors_from_matchup(matchup)}.flatten.uniq
  end

  def self.get_competitors_from_matchup(matchup: {'title' => 'no match entered'})
    puts "          parsing competitors from match: #{matchup['title']}"

    # returns an array of competitor hashes with keys:
    # id, name, country, short_name, images, race
    matchup["competitors"]
  end

  def self.fetch_matches_by_tournament_id(tournament_id: 1005, api_key: @@api_key)
    puts "    fetching matches by tournament_id: #{tournament_id}"

    filter = "&tournaments[]=" + tournament_id.to_s
    matches = HTTParty.get(@@matches_root + api_key + filter)

    # add tournament_id foreign key
    matches.each {|m| m['tournament_id'] = tournament_id}

    # returns an array of match hashes with keys:
    # id, title, start, end, bestOf, tournament_id
    matches
  end

  def self.fetch_matchups_by_match_id(match_id: 49526, api_key: @@api_key)
    puts "      fetching matchups by match_id: #{match_id}"

    filter = "&with[]=matchups"
    match  = HTTParty.get(@@matches_root + "/#{match_id}" + api_key + filter)

    matchups = match["matchups"]
    matchups.each {|m| m['match_id'] = match_id}

    # returns an array of matchup hashes with keys:
    # id, competitors, match_id
    matchups
  end
end