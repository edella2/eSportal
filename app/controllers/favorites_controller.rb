class FavoritesController < ApplicationController
  def create
    Favorite.create(favorite_params)
    redirect_to :back
  end

  def destroy
    redirect_to :back
  end

  private

  def favorite_params
    params.require(:favorite).permit(:favoritable_id, :user_id, :favoritable_type)
  end
end
