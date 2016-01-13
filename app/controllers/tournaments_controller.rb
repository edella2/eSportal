require 'will_paginate/array'
class TournamentsController < ApplicationController
  def index
    @games = Game.all

    case params[:sort_option]
    when "search"
      @tournaments = Tournament.search(params[:search])
      @tournaments = @tournaments.paginate(page: params[:page], per_page: 12, total_pages: 2)
      respond_to do |format|
        format.html
        format.js
      end
    when "year"
      @tournaments = Tournament.by_year
      @tournaments = @tournaments.paginate(page: params[:page], per_page: 12, total_pages: 2)
      respond_to do |format|
        format.html
        format.js
      end
    when "month"
      @tournaments = Tournament.by_month
      @tournaments = @tournaments.paginate(page: params[:page], per_page: 12, total_pages: 2)
      respond_to do |format|
        format.html
        format.js
      end
    when "week"
      @tournaments = Tournament.by_week
      @tournaments = @tournaments.paginate(page: params[:page], per_page: 12, total_pages: 2)
      respond_to do |format|
        format.html
        format.js
      end
    when "day"
      @tournaments = Tournament.by_day
      @tournaments = @tournaments.paginate(page: params[:page], per_page: 12, total_pages: 2)
      respond_to do |format|
        format.html
        format.js
      end
    when "game"
      @tournaments = Tournament.where(game_id: params[:game_id]).to_a
      @tournaments = @tournaments.paginate(page: params[:page], per_page: 12, total_pages: 2)
      respond_to do |format|
        format.html
        format.js
      end
    else
      @tournaments = Tournament.all.to_a
      @tournaments = @tournaments.paginate(page: params[:page], per_page: 12, total_pages: 2)
      respond_to do |format|
        format.html
        format.js
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
    params.require(:tournament).permit(:name, :start, :end, :game_id, :image, :page)
  end
end
