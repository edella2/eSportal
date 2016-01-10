FactoryGirl.define do
  sequence :stream do |n|
    title         "Stream for Tournament #{n}"
    link          Faker::Internet.url
    language      "English"
    tournament_id n
  end
end
