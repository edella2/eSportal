class ApplicationController < ActionController::Base
  class Abios
    def initialize
      @games_root       = "https://api.abiosgaming.com/v1/games"
      @matches_root     = "https://api.abiosgaming.com/v1/matches"
      @competitors_root = "https://api.abiosgaming.com/v1/competitors"
      @tournaments_root = "https://api.abiosgaming.com/v1/tournaments"

      @api_key          = "?access_token=#{ENV['ABIOS_API_KEY']}"
    end

    def get_games
      puts "fetching all games"

      HTTParty.get(@games_root + @api_key)
    end

    def get_tournaments
      puts "fetching all tournaments"

      HTTParty.get(@tournaments_root + @api_key)
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

    # these can only fetch 3 pages of 15 records due to API constraints

    # def get_tournaments_by_game(game_id)
    #   puts "fetching tournaments by game_id: #{game_id}"

    #   filter = "&games[]=" + game_id.to_s
    #   HTTParty.get(@tournaments_root + @api_key + filter)
    # end

    # def get_tournaments_with_matches_by_game(game_id)
    #   puts "fetching tournaments by game_id: #{game_id}"

    #   filter = "&with[]=matches&game[]=#{game_id}"
    #   HTTParty.get(@tournaments_root + @api_key + filter)
    # end

    # def get_matches_with_competitors
    # end
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
