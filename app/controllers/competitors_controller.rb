class CompetitorsController < ApplicationController
  def index
    @competitors = Competitor.all
  end

  def show
    @competitor = Competitor.find_by(competitor_params)
  end

  private

  def competitor_params
    params.permit(:id, :name)
  end
end
