class Competitor < ActiveRecord::Base
  #can be favorited
  has_many :favorites, as: :favoritable

  has_and_belongs_to_many :tournaments
end
