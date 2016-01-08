

class Abios
  def initialize
    @api_key          = "?access_token=#{ENV['ABIOS_API_KEY']}"
    @games_root       = "https://api.abiosgaming.com/v1/games"
    @matches_root     = "https://api.abiosgaming.com/v1/matches"
    @competitors_root = "https://api.abiosgaming.com/v1/competitors"
    @tournaments_root = "https://api.abiosgaming.com/v1/tournaments"
  end

  def get_games
    HTTParty.get(@games_root + @api_key)
  end

  def get_tournaments
    HTTParty.get(@tournaments_root + @api_key)
  end

  def get_competitors
    # TODO
  end

  def get_competitors_by_tournament(tournament_id)
    filter = "&tournaments[]=" + tournament_id.to_s
    HTTParty.get(@competitors_root + @api_key + filter)
  end

  def get_stream_by_tournament(tournament_id)
    HTTParty.get(@tournaments_root + "/" + tournament_id.to_s + @api_key).fetch("url")
  end

  def get_tournaments_by_game(game_id)
    filter = "&games[]=" + game_id.to_s
    HTTParty.get(@tournaments_root + @api_key + filter)
  end

  private

  def get_matches
    HTTParty.get(@matches + @api_key)
  end

  def get_matches_by_tournament(tournament_id)
    filter = "&tournaments[]=" + tournament_id.to_s
    HTTParty.get(@matches_root + @api_key + filter)
  end
end