class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.order("created_at DESC")
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
end
