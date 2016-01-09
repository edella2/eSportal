FactoryGirl.define do
  sequence :tournament do |n|
    name       "Tournament #{n}"
    image      Faker::Internet.url
    start_date 3.days.ago
    end_date   3.days.since
    game_id    1
  end
end
