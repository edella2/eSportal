class Tournament < ActiveRecord::Base
  # Can be favorited
  has_many :favorites, as: :favoritable
  has_many :streams
  has_and_belongs_to_many :competitors
  belongs_to :game

  def self.search(query)
    long_title = where("lower(title) like ?", "%#{query.downcase}%")
    short_title = where("lower(short_title) like ?", "%#{query.downcase}%")
    competitors = Competitor.where("lower(name) like ?", "%#{query.downcase}%")
    tournaments_with_competitor = []

    competitors.each do |competitor|
      tournaments_with_competitor += competitor.tournaments
    end
    (long_title + short_title + tournaments_with_competitor).uniq
  end

  def is_live?
    self.start <= DateTime.now && self.end >= DateTime.now
  end

  def start_time
    self.start ##Where 'start' is a attribute of type 'Date' accessible through MyModel's relationship
  end

  # # deactivated
  # def self.update_data
  #   tournament_data = HTTParty.get("https://api.abiosgaming.com/v1/tournaments?access_token=#{ENV['ABIOS_API_KEY']}")
  #   update_or_create(tournament_data)
  # end

  private

  # # deactivated
  # def self.update_or_create(tournaments)
  #   p tournaments[0]
  #   tournaments.each do |tournament|
  #     Tournament.find_or_initialize_by(
  #       id: tournament["id"],
  #       title: tournament["title"],
  #       start: DateTime.parse(tournament["start"]),
  #       end: DateTime.parse(tournament["end"]),
  #       image: tournament["images"]["default"]

  #       ).update_attributes!(
  #       id: tournament["id"],
  #       title: tournament["title"],
  #       start: DateTime.parse(tournament["start"]),
  #       end: DateTime.parse(tournament["end"]),
  #       image: tournament["images"]["default"]
  #       )
  #   end
  # end
end

# class Tournament
#     self.per_page = 10
# end