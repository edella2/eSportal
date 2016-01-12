require "rails_helper"

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

RSpec.feature "Users can see tournaments" do
  let!(:tournament) { FactoryGirl.create(:tournament, :past) }
  context "with valid tournaments" do
    scenario "has a shortened title", js: true do
      visit "/"

      expect(page).to have_content "tourny"
    end

    scenario "has a shortened title", js: true do
      visit "/"

      find('img').hover
      sleep(4)


      expect(page).to have_content "tourny"
    end
  end
end
# describe "the signin process", :type => :feature, js:true do
#   let!(:user) { FactoryGirl.create(:user) }
#   let!(:tournament) { FactoryGirl.create(:tournament, :current) }

#   scenario "with search bar" do
#     visit "/tournaments"
#     sleep(4)



#     expect(page).to have_content "Search"
#     # expect(page).to have_content "Signed in as #{user.email}"
#   end
# end

