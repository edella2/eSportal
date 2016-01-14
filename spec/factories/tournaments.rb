FactoryGirl.define do
  factory :tournament do
    sequence(:title)       {|n| "tournament #{n}"}
    sequence(:short_title) {|n| "tourney #{n}"}
    image             Faker::Avatar.image
    thumbnail         Faker::Avatar.image
    large             Faker::Avatar.image
    description       Faker::Hacker.say_something_smart
    short_description Faker::Hacker.say_something_smart
    city              Faker::Address.city

    trait :past do
      start_time        {DateTime.now - 5}
      end_time          {DateTime.now - 2}
    end

    trait :current  do
      start_time        {DateTime.now - 3}
      end_time          {DateTime.now + 3}
    end

    trait :upcoming do
      start_time        {DateTime.now + 3}
      end_time          {DateTime.now + 6}
    end
  end
end



