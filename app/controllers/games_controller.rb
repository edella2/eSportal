class GamesController < ApplicationController

  def show
    @game = Game.find(params[:id])
    @tournaments = @game.tournaments
    @games = Game.all
    if params[:search]
      @tournaments = Tournament.search(params[:search]).select {|tournament| tournament.title == @game.name}
    else
      if params[:calendar_sort]
        @tournaments = @tournaments.select {|tournament| tournament.game.title == params[:calendar_sort]}
        p @tournaments
        render 'tournaments/index_calendar'
      else
        @tournaments_live = @tournaments.select {|tournament| tournament.is_live?}
        @tournaments_not_live = @tournaments.select {|tournament| !tournament.is_live?}.sort{|tournament_1, tournament_2| tournament_2.start <=> tournament_1.start}
        render 'tournaments/index'
      end
    end
  end

  def index_calendar

    if params[:search]
      @tournaments = Tournament.search(params[:search]).order(created_at: :desc)
    else
      case params[:sort_option]
      when "year"
        @tournaments = sort_tournaments_by_year.paginate(page: params[:page], per_page: 12, total_pages: 2)
      when "month"
        @tournaments = sort_tournaments_by_month.paginate(page: params[:page], per_page: 12, total_pages: 2)
      when "week"
        @tournaments = sort_tournaments_by_week.paginate(page: params[:page], per_page: 12, total_pages: 2)
      when "day"
        @tournaments = sort_tournaments_by_day.paginate(page: params[:page], per_page: 12, total_pages: 2)
      else
        @tournaments = Tournament.order(created_at: :desc)
      end
    end
    @games = Game.all
    render 'tournaments/index_calendar'
  end
end
