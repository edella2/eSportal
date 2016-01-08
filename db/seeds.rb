# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
past_tournaments = 20
current_tournaments = 5
future_tournaments = 20
total_tournaments = past_tournaments + current_tournaments + future_tournaments

require 'factory_girl_rails'

FactoryGirl.define do

  factory :tournament do
    name          Faker::Lorem.word
    image         Faker::Avatar.image

    trait :past do
      start_date  Faker::Date.between(10.days.ago, 5.days.ago)
      end_date    Faker::Date.between(4.days.ago, 1.days.ago)
    end

    trait :current do
      start_date  Faker::Date.between(3.days.ago, 2.days.ago)
      end_date    Faker::Date.between(1.days.since, 7.days.since)
    end

    trait :future do
      start_date  Faker::Date.between(3.days.since, 6.days.since)
      end_date    Faker::Date.between(7.days.since, 10.days.since)
    end
  end

  factory :stream do
    title         Faker::Hipster.word
    link          Faker::Internet.url
    language      Faker::Lorem.word
    tournament_id Faker::Number.between(1, total_tournaments)
  end

  factory :team do
    name          Faker::Team.name
    tournament_id Faker::Number.between(1, total_tournaments)
  end


end



# past_tournaments.times { FactoryGirl.create(:tournament, :past) }
# current_tournaments.times { FactoryGirl.create(:tournament, :current) }
# future_tournaments.times { FactoryGirl.create(:tournament, :future) }

# total_tournaments.times { FactoryGirl.create(:stream) }
# (total_tournaments * 6).times { FactoryGirl.create(:team) }

FactoryGirl.create_list(:tournament, past_tournaments, :past)
FactoryGirl.create_list(:tournament, current_tournaments, :current)
FactoryGirl.create_list(:tournament, future_tournaments, :future)
FactoryGirl.create_list(:stream, total_tournaments)
FactoryGirl.create_list(:team, total_tournaments * 6)

