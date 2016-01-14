class TournamentsController < ApplicationController

  def index
    @games = Game.all
    cookies[:welcomed] = {:value => true, :expires => Time.now + 6.months}

    case params[:sort_option]
    when "search"
      @tournaments = Search.new(params[:search]).matches
    when "year"
      @tournaments = Tournament.by_year
    when "month"
      @tournaments = Tournament.by_month
    when "week"
      @tournaments = Tournament.by_week
    when "day"
      @tournaments = Tournament.by_day
    when "game"
      @tournaments = Tournament.where(game_id: params[:game_id]).order(start: :desc)
      @title = Game.find(params[:game_id]).title
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

  def update
    @tournament = Tournament.find(params[:id])
    @tournament.find_or_initialize_by(tournament_params)
    if @tournament.save
      redirect_to tournament_path(@tournament)
    else
      flash.now[:danger] = @tournament.errors.full_messages
      render 'edit'
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :start, :end, :game_id, :image, :page)
  end
end
