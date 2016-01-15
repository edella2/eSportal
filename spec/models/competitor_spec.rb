require 'rails_helper'

RSpec.describe Competitor, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:competitor, name: generate(:name))).to be_valid
  end

  describe '#save/create' do
    it 'does not allow anonymous records' do
      nameless_guy = FactoryGirl.build(:competitor, name: nil)
      expect(nameless_guy).not_to be_valid
    end

    it 'does not allow duplicate names' do
      duplicate_competitor = FactoryGirl.build(:competitor, name: created_competitor.name)
      expect(duplicate_competitor).not_to be_valid
    end
  end

  describe '#tournaments' do
    it 'lists all tournaments in which it participated' do
      competitor = FactoryGirl.create(:competitor, name: generate(:name))
      5.times {competitor.tournaments << FactoryGirl.create(:tournament)}
      expect(competitor.tournaments.all?{|c| c.class == Competitor}).to eq true
    end
  end

  # describe '#favorites' do
  #   pending 'lists all favorite tournaments' do
  #   end

  #   pending 'lists all favorite competitors' do
  #   end
  # end
end
