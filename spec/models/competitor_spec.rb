require 'rails_helper'

RSpec.describe Competitor, type: :model do
  it 'has a valid factory' do
    expect(Factory.create(:competitor)).to be_valid
  end

  it 'is invalid without a name' do
    # expe
  end

  pending 'can list multiple tournaments in which it participated' do
  end

  pending 'can have favorite tournaments' do
  end

  pending 'can have favorite competitors' do
  end
end
