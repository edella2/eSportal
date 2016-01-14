FactoryGirl.define do
  factory :competitor do |f|
    f.name  {Faker::Hipster.word}
  end
end
