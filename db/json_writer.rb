require_relative '../app/models/abios'
require 'httparty'
require 'json'
require 'dotenv'

Dotenv.load

api_key          = "?access_token=#{ENV['ABIOS_API_KEY']}"

games_backup       = File.expand_path('.' + '/db/api_response_backups/games_backup.json')
tournaments_backup = File.expand_path('.' + '/db/api_response_backups/tournaments_backup.json')
matches_backup     = File.expand_path('.' + '/db/api_response_backups/matches_backup.json')
matchups_backup    = File.expand_path('.' + '/db/api_response_backups/matchups_backup.json')

games       = Abios.fetch_games(api_key)
# temporary limit on games
games = [games[2]]

tournaments = games.map {|g| Abios.fetch_tournaments_by_game_id(g['id'], api_key)}.flatten
# temporary limit on tournaments
tournaments = tournaments.first(3)

matches     = tournaments.map {|t| Abios.fetch_matches_by_tournament_id(t['id'], api_key)}.flatten
# temporary limit on matches
matches = matches.first(3)

matchups    = matches.map {|m| Abios.fetch_matchups_by_match_id(m['id'], api_key)}.flatten
# # temporary limit on matchups
matchups = matchups.first(3)

File.open(games_backup, 'w+') do |f|
  games.each {|game| f.puts game.to_json}
end

File.open(tournaments_backup, 'w+') do |f|
  tournaments.each {|tournament| f.puts tournament.to_json}
end

File.open(matches_backup, 'w+') do |f|
  matches.each {|match| f.puts match.to_json}
end

File.open(matchups_backup, 'w+') do |f|
  matchups.each {|matchup| f.puts matchup.to_json}
end