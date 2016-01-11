class Favorite < ActiveRecord::Base
  belongs_to :favoritable, polymorphic: true
  belongs_to :user, inverse_of: :favorites

  scope :competitors, -> { where(favoritable_type: 'Competitor') }
  scope :tournaments, -> { where(favoritable_type: 'Tournament') }

  validates :user_id, uniqueness: {
    scope: [:favoritable_id, :favoritable_type],
    message: 'can only favorite an item once'
  }
end
