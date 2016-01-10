class TimertestsController < ApplicationController
	def index
		if params[:search]
      @tournaments = Tournament.search(params[:search]).order("created_at DESC")
    else
      case params[:sort_option]
      when "year"
        @tournaments = sort_tournaments_by_year
      when "month"
        @tournaments = sort_tournaments_by_month
      when "week"
        @tournaments = sort_tournaments_by_week
      when "day"
        @tournaments = sort_tournaments_by_day
      else
        @tournaments = Tournament.order('created_at DESC')
      end
    end
	end
end
