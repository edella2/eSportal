require_relative '../app/models/abios'
require 'httparty'
require 'json'
require 'dotenv'

Dotenv.load

api_key = "?access_token=#{ENV['ABIOS_API_KEY']}"

games_backup       = File.expand_path('.' + '/db/api_response_backups/games_backup.json')
tournaments_backup = File.expand_path('.' + '/db/api_response_backups/tournaments_backup.json')
matches_backup     = File.expand_path('.' + '/db/api_response_backups/matches_backup.json')
matchups_backup    = File.expand_path('.' + '/db/api_response_backups/matchups_backup.json')

games       = Abios.fetch_games(api_key: api_key)

# temporary limit on games (must be an array)
# games = [games[4]]

tournaments = games.map do |game|
  Abios.fetch_tournaments_by_game_id(game_id: game['id'], api_key: api_key)
end
tournaments.flatten!

# temporary limit on tournaments (must be an array)
# tournaments = tournaments.first(8)

matches = tournaments.map do |tourn|
  Abios.fetch_matches_by_tournament_id(tournament_id: tourn['id'], api_key: api_key)
end
matches.flatten!

# # temporary limit on matches (must be an array)
# matches = matches.first(4)

matchups = matches.map do |match|
  Abios.fetch_matchups_by_match_id(match_id: match['id'], api_key: api_key)
end
matchups.flatten!

# # temporary limit on matchups (must be an array)
# matchups = matchups.first(3)

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
