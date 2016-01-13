class Tournament < ActiveRecord::Base
  # Can be favorited
  has_many :favorites, as: :favoritable
  has_many :streams
  has_and_belongs_to_many :competitors
  belongs_to :game

  # TODO: this should be moved out of the tournament model if we start displaying competitor pages in results
  def self.search(query)
    tournament_matches = where("LOWER(title) LIKE ?", "%#{query.downcase}%")
    tournament_matches += where("LOWER(short_title) LIKE ?", "%#{query.downcase}%")
    competitor_matches = Competitor.where("LOWER(name) LIKE ?", "%#{query.downcase}%")
    competitor_matches_tournaments = competitor_matches.map {|c| c.tournaments}.flatten

    tournament_matches + competitor_matches_tournaments
  end

  def is_live?
    self.start <= DateTime.now && self.end >= DateTime.now
  end

  # This is needed for the calendar plugin
  def start_time
    self.start
  end
end

