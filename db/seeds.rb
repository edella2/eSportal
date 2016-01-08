require "pp"

class Abios
  def initialize
    @api_key          = ENV["ABIOS_API_KEY"]
    @games_root       = "https://api.abiosgaming.com/v1/games?access_token="
    @matches_root     = "https://api.abiosgaming.com/v1/matches?access_token="
    @competitors_root = "https://api.abiosgaming.com/v1/competitors?access_token="
    @tournaments_root = "https://api.abiosgaming.com/v1/tournaments?access_token="
    @streams_root     = "" #TBD
  end

  def get_games
    HTTParty.get(@games_root + @api_key)
  end

  def get_tournaments
    HTTParty.get(@tournaments_root + @api_key)
  end

  def get_competitors
  end

  def get_competitors_by_tournament(tournament_id)
    filter = "&tournament[]=" + tournament_id.to_s
    HTTParty.get(@competitors_root + @api_key + filter)
  end

  def get_streams_by_tournament(tournament_id)
  end

  # not working yet
  def get_tournaments_by_game(game_id)
    filter = "&games[]=" + game_id.to_s
    HTTParty.get(@tournaments_root + @api_key + filter)
  end

  private

  def get_matches
  end

  def get_matches_by_tournament(tournament_id)
    filter = "&tournament[]=" + tournament_id.to_s
    HTTParty.get(@matches_root + @api_key + filter)
  end
end

binding.pry