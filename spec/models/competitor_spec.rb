require 'rails_helper'

RSpec.describe Competitor, type: :model do
  let(:created_competitor) { Competitor.create(
      name:                    "HungryBear",
      country_name:            "United States",
      country_short_name:      "USA",
      country_image_default:   Faker::Internet.url,
      country_image_thumbnail: Faker::Internet.url,
      race:                    nil
    )
  }
  let(:built_competitor)   { Competitor.build(
      name:                    "ThirstyBear",
      country_name:            "United States",
      country_short_name:      "USA",
      country_image_default:   Faker::Internet.url,
      country_image_thumbnail: Faker::Internet.url,
      race:                    nil
    )
  }

  it 'has a valid factory' do
    expect(FactoryGirl.create(:competitor)).to be_valid
  end

  describe '#save/create' do
    it 'does not allow anonymous competitors' do
      nameless_guy = FactoryGirl.build(:competitor, name: nil)
      expect(nameless_guy.save).not_to be_valid
    end

    it 'does not allow duplicate entries' do
      duplicate_competitor = created_competitor.dup
      expect(duplicate_competitor.save).not_to be_valid
    end
  end

  describe '#tournaments' do
    pending 'lists all tournaments in which it participated' do
      #
    end
  end

  describe '#favorites' do
    pending 'lists all favorite tournaments' do
    end

    pending 'lists all favorite competitors' do
    end
  end
end
