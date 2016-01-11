require 'csv'
require 'pry-rails'

abios_backup_file = File.expand_path('.' + '/db/abios_backup.csv')

File.open(abios_backup_file, 'w') do |file|
  file.write("hiiiii")
end

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

