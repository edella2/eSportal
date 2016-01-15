class UsersController < ApplicationController
  def show
    @user = User.find(user_params[:id])

    favorite_tournaments = @user.favorites.where(favoritable_type: "Tournament")
    @favorite_tournaments = favorite_tournaments.map {|t| Tournament.find(t.favoritable_id)}.sort_by {|t| t.title.downcase}

    favorite_competitors = @user.favorites.where(favoritable_type: "Competitor")
    @favorite_competitors = favorite_competitors.map {|c| Competitor.find(c.favoritable_id)}.sort_by {|c| c.name.downcase}
  end

  private

  def user_params
    params.permit(:id)
  end
end
