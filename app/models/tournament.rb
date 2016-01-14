class Tournament < ActiveRecord::Base
  # Can be favorited
  has_many :favorites, as: :favoritable
  has_many :streams
  has_and_belongs_to_many :competitors
  belongs_to :game

  def self.by_year
    where("start > ?", "#{(DateTime.now - 365).strftime("%F")}").order('start DESC')
  end

  def self.by_month
    where("start > ?", "#{(DateTime.now - 30).strftime("%F")}").order('start DESC')
  end

  def self.by_week
    where("start > ?", "#{(DateTime.now - 7).strftime("%F")}").order('start DESC')
  end

  def self.by_day
    where("start > ?", "#{(DateTime.now - 1).strftime("%F")}").order('start DESC')
  end

  def is_live?
    self.start <= DateTime.now && self.end >= DateTime.now
  end

  def is_over?
    self.end <= DateTime.now
  end

  # This is needed for the calendar plugin
  def start_time
    self.start
  end
end
