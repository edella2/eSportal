FactoryGirl.define do
  factory :tournament do
    sequence(:name)   {|n| "tournament #{n}"}
    sequence(:short_title) {|n| "tourny #{n}"}
    image             Faker::Avatar.image
    thumbnail         Faker::Avatar.image
    large             Faker::Avatar.image
    description       Faker::Hacker.say_something_smart
    short_description Faker::Hacker.say_something_smart
    city              Faker::Address.city


    trait :past do
      start        DateTime.now - 5
      end          DateTime.now - 2
    end

    trait :current  do
      start        DateTime.now - 3
      end          DateTime.now + 3
    end

    trait :upcoming do
      start        DateTime.now + 3
      end          DateTime.now + 6
    end
  end
end



