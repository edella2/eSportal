class Tournament < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :streams

  def update
    tournament_data = httparty(https://api.abiosgaming.com/v1/matches?access_token=ENV['ABIOS_API_KEY'])
  end

end
