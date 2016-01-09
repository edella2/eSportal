class Competitor < ActiveRecord::Base
  has_and_belongs_to_many :tournaments
end
