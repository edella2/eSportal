FactoryGirl.define do
  sequence :game do |n|
    game_id n
    name    "Game #{n}"
  end
end
