FactoryGirl.define do
  sequence :stream do |n|
    title         "Tournament Stream"
    link          Faker::Internet.url
    language      "English"
    tournament_id ""
  end
end
