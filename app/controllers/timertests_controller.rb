class TimertestsController < ApplicationController
	def index
		@tournaments = Tournament.all
	end
end
