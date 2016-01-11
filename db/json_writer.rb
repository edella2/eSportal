require_relative '../app/models/abios'
require 'httparty'
require 'json'
require 'pry'
require 'dotenv'

Dotenv.load

api_key          = "?access_token=#{ENV['ABIOS_API_KEY']}"

games_backup       = File.expand_path('.' + '/db/api_response_backups/games_backup.json')
tournaments_backup = File.expand_path('.' + '/db/api_response_backups/tournaments_backup.json')
matches_backup     = File.expand_path('.' + '/db/api_response_backups/matches_backup.json')
matchups_backup    = File.expand_path('.' + '/db/api_response_backups/matchups_backup.json')
competitors_backup = File.expand_path('.' + '/db/api_response_backups/competitors_backup.json')

File.open(games_backup, 'w+') do |f|
  f.write(Abios.fetch_games(api_key))
end

# File.open(tournaments_backup, 'a+') do |f|
#   f.write(HTTParty.get(tournaments_root + api_key).to_json)
# end



# GAMES       = abios.fetch_games
# TOURNAMENTS = GAMES.map {|game| abios.fetch_tournaments_by_game(game["id"])}.flatten

# GAMES.each do |game_hash|
#   if game_hash
#     puts "writing game to /abios_backup.csv: #{game_hash['title']}"

#     Game.find_or_create_by(
#       id:   game_hash["id"],
#       name: game_hash["title"]
#       )
#   else
#     puts "no game data for this record!"
#   end
# end


