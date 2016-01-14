class TournamentsController < ApplicationController
  def index
    @games = Game.all
    cookies[:welcomed] = {:value => true, :expires => Time.now + 6.months}

    if params[:sort_option] == "search"
      @tournaments = Search.new(params[:search]).matches
    elsif params[:sort_option] == "game"
      @tournaments = Tournament.where(game_id: params[:game_id]).order(start: :desc)
      @title = Game.find(params[:game_id]).title
    elsif params[:sort_option].in? ["year", "month", "week", "day"]
      @tournaments = Tournament.send("by_" + params[:sort_option])
    else
      @tournaments = Tournament.all.order(start: :desc)
      @title = ""
    end

    @title ||= params[:sort_option].capitalize

    @tournaments = @tournaments.partition {|tournament| tournament.is_live?}.flatten
    @tournaments = @tournaments.paginate(page: params[:page], per_page: 12)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def index_calendar
    @games = Game.all
    @tournaments = Tournament.order(created_at: :desc)
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :start, :end, :game_id, :image, :page)
  end
end
