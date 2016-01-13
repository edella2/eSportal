module GamesHelper

  def get_game_title(id)
    Game.find(id).title
  end

end
