# this class facilitates interaction with the Abios API from within the controllers
module Abios
  @@games_root       = "https://api.abiosgaming.com/v1/games"
  @@matches_root     = "https://api.abiosgaming.com/v1/matches"
  @@competitors_root = "https://api.abiosgaming.com/v1/competitors"
  @@tournaments_root = "https://api.abiosgaming.com/v1/tournaments"
  @@api_key          = "?access_token=#{ENV['ABIOS_API_KEY']}"

  def self.fetch_games(api_key = @@api_key)
    puts "fetching all games"

    # returns an array of game hashes with keys:
    # id, title, long_title, images
    HTTParty.get(@@games_root + api_key)
  end

  def self.fetch_tournaments_by_game(game_id, api_key = @@api_key)
    puts "  fetching current tournaments by game_id: #{game_id}"

    filter = "&games[]=" + game_id.to_s

    # returns an array of tournament hashes with keys:
    # id, title, start, end, city, short_title, url, description, short_description,
    #   images, links, game
    HTTParty.get(@@tournaments_root + api_key + filter)
  end

  def self.fetch_competitors_by_tournament(tournament_id, api_key = @@api_key)
    puts "    fetching competitors by tournament_id: #{tournament_id}"

    matches     = fetch_matches_by_tournament_id(tournament_id)
    matchups    = matches.map {|match| fetch_matchups_by_match_id(match["id"])}.flatten

    # returns an array of competitor hashes with keys:
    # id, name, country, short_name, images, race
    matchups.map {|matchup| get_competitors_from_matchup(matchup)}.flatten.uniq
  end

  private

  def self.fetch_matches_by_tournament_id(tournament_id, api_key = @@api_key)
    puts "      fetching matches by tournament_id: #{tournament_id}"

    filter = "&tournaments[]=" + tournament_id.to_s

    # returns an array of match hashes with keys:
    # id, title, start, end, bestOf
    HTTParty.get(@@matches_root + @@api_key + filter)
  end

  def self.fetch_matchups_by_match_id(match_id, api_key = @@api_key)
    puts "        fetching matchups by match_id: #{match_id}"

    filter = "&with[]=matchups"
    match  = HTTParty.get(@@matches_root + "/#{match_id}" + @@api_key + filter)

    # returns an array of matchup hashes with keys:
    # id, competitors
    match["matchups"]
  end

  def self.get_competitors_from_matchup(matchup, api_key = @@api_key)
    puts "          parsing competitors from match_id: #{matchup['id']}"

    # returns an array of competitor hashes with keys:
    # id, name, country, short_name, images, race
    matchup["competitors"]
  end

  # # methods below this point are not needed in current version
  # # ***************************************************************************

  # # don't use if tournaments already fetched
  # def self.fetch_stream_by_tournament(tournament_id, api_key = @@api_key)
  #   puts "fetching stream by tournament_id: #{tournament_id}"

  #   HTTParty.get(@@tournaments_root + "/#{tournament_id.to_s}" + @@api_key).fetch("url")
  # end

  # def self.fetch_matches
  #   puts "fetching current matches"

  #   HTTParty.get(@@matches_root + @@api_key)
  # end

  # def self.fetch_tournaments_by_game(game_id, api_key = @@api_key)
  #   puts "fetching tournaments by game_id: #{game_id}"

  #   filter = "&games[]=" + game_id.to_s
  #   HTTParty.get(@@tournaments_root + @@api_key + filter)
  # end

  # def self.fetch_tournaments_with_matches_by_game(game_id, api_key = @@api_key)
  #   puts "fetching tournaments by game_id: #{game_id}"

  #   filter = "&with[]=matches&game[]=#{game_id}"
  #   HTTParty.get(@@tournaments_root + @@api_key + filter)
  # end

  # def self.fetch_matches_with_competitors
  # end

  # def self.fetch_tournaments
  #   puts "fetching current tournaments"

  #   HTTParty.get(@@tournaments_root + @@api_key)
  # end
end