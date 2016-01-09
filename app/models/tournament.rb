class Tournament < ActiveRecord::Base
  has_many :competitors
  has_and_belongs_to_many :games
  has_many :streams
end
