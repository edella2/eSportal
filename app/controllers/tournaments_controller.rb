class TournamentsController < ApplicationController
  def index
    p params
    case params[:sort_option]
    when "year"
      p "In year"
      @tournaments = sort_tournaments_by_year
    when "month"
      p "In month"
      @tournaments = sort_tournaments_by_month
    when "week"
      p "In week"
      @tournaments = sort_tournaments_by_week
    when "day"
      p "In day"
      @tournaments = sort_tournaments_by_day
    else
      p "In Default"
      @tournaments = Tournament.order('created_at DESC')
    end
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
    params.require(:tournament).permit(:name, :start_time, :end_date, :game_id, :image)
  end

  def sort_tournaments_by_year
    @tournaments = Tournament.all

    @tournaments.select {|tournament| tournament.start_date > DateTime.now - 365}
  end
  def sort_tournaments_by_month
    @tournaments = Tournament.all

    @tournaments.select {|tournament| tournament.start_date > DateTime.now - 30}
  end
  def sort_tournaments_by_week
    @tournaments = Tournament.all

    @tournaments.select {|tournament| tournament.start_date > DateTime.now - 7}
  end
  def sort_tournaments_by_day
    @tournaments = Tournament.all

    @tournaments.select {|tournament| tournament.start_date > DateTime.now - 1}
  end
end

