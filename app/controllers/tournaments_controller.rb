require 'will_paginate/array'
class TournamentsController < ApplicationController
  def index
    @games = Game.all
    if params[:search]
      @tournaments = Tournament.search(params[:search]).paginate(page: params[:page], per_page: 12)
    else

      case params[:sort_option]
      when "year"
        @tournaments = sort_tournaments_by_year.paginate(page: params[:page], per_page: 12)
      when "month"
        @tournaments = sort_tournaments_by_month.paginate(page: params[:page], per_page: 12)
      when "week"
        @tournaments = sort_tournaments_by_week.paginate(page: params[:page], per_page: 12)
      when "day"
        @tournaments = sort_tournaments_by_day.paginate(page: params[:page], per_page: 12)
      else
        require 'will_paginate/array'
        @tournaments = Tournament.all
        @tournaments_live = @tournaments.select {|tournament| tournament.is_live?}
        @tournaments_not_live = @tournaments.select {|tournament| !tournament.is_live?}
        @games = Game.all

        @tournaments = @tournaments_live + @tournaments_not_live

        @tournaments = @tournaments.paginate(page: params[:page], per_page: 12)

        respond_to do |format|
          format.html
          format.js
        end
      end
    end
  end

  def index_calendar
    @games = Game.all
    if params[:search]
      @tournaments = Tournament.search(params[:search]).order(created_at: :desc)
    else
      case params[:sort_option]
      when "year"
        @tournaments = sort_tournaments_by_year.paginate(page: params[:page], per_page: 12)
      when "month"
        @tournaments = sort_tournaments_by_month.paginate(page: params[:page], per_page: 12)
      when "week"
        @tournaments = sort_tournaments_by_week.paginate(page: params[:page], per_page: 12)
      when "day"
        @tournaments = sort_tournaments_by_day.paginate(page: params[:page], per_page: 12)
      else
        @tournaments = Tournament.order(created_at: :desc)
      end
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

  def tournament_sort(type)
    case type
    when "year"
      @tournaments = sort_tournaments_by_year
    when "month"
      @tournaments = sort_tournaments_by_month
    when "week"
      @tournaments = sort_tournaments_by_week
    when "day"
      @tournaments = sort_tournaments_by_day
    else
      @tournaments = Tournament.order(:start)
    end
  end

  def tournament_params
    params.require(:tournament).permit(:name, :start, :end, :game_id, :image)
  end

  def sort_tournaments_by_year
    @tournaments = Tournament.all

    @tournaments.select {|tournament| tournament.start > DateTime.now - 365}
  end

  def sort_tournaments_by_month
    @tournaments = Tournament.all

    @tournaments.select {|tournament| tournament.start > DateTime.now - 30}
  end

  def sort_tournaments_by_week
    @tournaments = Tournament.all

    @tournaments.select {|tournament| tournament.start > DateTime.now - 7}
  end

  def sort_tournaments_by_day
    @tournaments = Tournament.all

    @tournaments.select {|tournament| tournament.start > DateTime.now - 1}
  end
end

