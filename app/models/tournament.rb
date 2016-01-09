class Tournament < ActiveRecord::Base
  # Can be favorited
  has_many :favorites, as: :favoritable

  has_many :streams
  has_and_belongs_to_many :competitors
  has_and_belongs_to_many :games

  include HTTParty

  def self.update_data
    tournament_data = HTTParty.get("https://api.abiosgaming.com/v1/tournaments?access_token=#{ENV['ABIOS_API_KEY']}")
    update_or_create(tournament_data)
  end

    def start_time
        self.start_date ##Where 'start' is a attribute of type 'Date' accessible through MyModel's relationship
    end

  private

  def self.update_or_create(tournaments)
    p tournaments[0]
    tournaments.each do |tournament|
      Tournament.find_or_initialize_by(
        id: tournament["id"],
        name: tournament["title"],
        start_time: DateTime.parse(tournament["start"]),
        end_date: DateTime.parse(tournament["end"]),
        image: tournament["images"]["default"]

        ).update_attributes!(
        id: tournament["id"],
        name: tournament["title"],
        start_time: DateTime.parse(tournament["start"]),
        end_date: DateTime.parse(tournament["end"]),
        image: tournament["images"]["default"]
        )
    end
  end

end

