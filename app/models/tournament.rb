class Tournament < ActiveRecord::Base
  # Can be favorited
  has_many :favorites, as: :favoritable
  has_many :streams
  has_and_belongs_to_many :competitors
  belongs_to :game

  def self.by_year(year: DateTime.now.year)
    where(
      start: year_start_date(year)..year_end_date(year),
      end:   year_start_date(year)..year_end_date(year)
      )
  end

  # expects month as integer
  def self.by_month(month: DateTime.now.month, year: DateTime.now.year)
    where(
      start: month_start_date(month, year)..month_end_date(month, year),
      end:   month_start_date(month, year)..month_end_date(month, year)
      )
  end

  def self.by_week(week: current_week_number, year: DateTime.now.year)
    where(
      start: week_start_date(week, year)..week_end_date(week, year),
      end:   week_start_date(week, year)..week_end_date(week, year)
      )
  end

  def self.by_day(date: DateTime.now)
    self.all.select {|t| t.is_live?(date: date)}
  end

  def is_live?(date: DateTime.now)
    self.start <= date && self.end >= date
  end

  def is_over?
    self.end <= DateTime.now
  end

  # This is needed for the calendar plugin
  def start_time
    self.start
  end

  private

  def self.year_start_date(year)
    Time.utc(year)
  end

  def self.year_end_date(year)
    year_start_date(year).end_of_year
  end

  def self.month_start_date(month, year)
    year_start_date(year) + (month - 1).months
  end

  def self.month_end_date(month, year)
    month_start_date(month, year).end_of_month
  end

  def self.week_start_date(week, year)
    (year_start_date(year) + (week - 1).weeks).beginning_of_week
  end

  def self.week_end_date(week, year)
    week_start_date(week, year).end_of_week
  end

  def self.current_week_number
    DateTime.now.strftime("%U").to_i
  end
end
