
class Tournament < ActiveRecord::Base

  has_many :competitors
  has_and_belongs_to_many :games
  include HTTParty

  has_many :streams

  def self.update_data
    tournament_data = HTTParty.get("https://api.abiosgaming.com/v1/tournaments?access_token=#{ENV['ABIOS_API_KEY']}")
    update_or_create(tournament_data)
  end

  private

  def self.update_or_create(tournaments)
    p tournaments[0]
    tournaments.each do |tournament|
      Tournament.find_or_initialize_by(
        id: tournament["id"],
        name: tournament["title"],
        start_date: DateTime.parse(tournament["start"]),
        end_date: DateTime.parse(tournament["end"]),
        image: tournament["images"]["default"]

        ).update_attributes!(
        id: tournament["id"],
        name: tournament["title"],
        start_date: DateTime.parse(tournament["start"]),
        end_date: DateTime.parse(tournament["end"]),
        image: tournament["images"]["default"]
        )
    end
  end

end

