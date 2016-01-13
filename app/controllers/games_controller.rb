class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
    @tournaments = @game.tournaments

    @tournaments_live = @tournaments.select {|tournament| tournament.is_live?}
    @tournaments_not_live = @tournaments.select {|tournament| !tournament.is_live?}.sort{|tournament_1, tournament_2| tournament_2.start <=> tournament_1.start}
    @games = Game.all
    render 'tournaments/index'
  end
end
