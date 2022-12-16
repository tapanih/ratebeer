require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "Iso 3", brewery: brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery: brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('Iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect {
      click_button "Create Rating"
    }.to change { Rating.count }.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "when ratings exist" do
    let!(:user2) { FactoryBot.create :user, username: "Matti" }

    before :each do
      FactoryBot.create :rating, score: 15, beer: beer1, user: user
      FactoryBot.create :rating, score: 20, beer: beer2, user: user
      FactoryBot.create :rating, score: 25, beer: beer2, user: user2
    end

    it "ratings page lists recent ratings" do
      visit ratings_path

      expect(page).to have_content "Iso 3 15"
      expect(page).to have_content "Karhu 20"
      expect(page).to have_content "Karhu 25"
    end

    it "user page shows information about user's ratings" do
      visit user_path(user)

      expect(page).to have_content "Has made 2 ratings, average rating 17.5"
      expect(page).to have_content "Iso 3 15"
      expect(page).to have_content "Karhu 20"
      expect(page).to_not have_content "Karhu 25"
    end

    it "rating can be deleted by the user who created it" do
      visit user_path(user)

      expect {
        within('tr', text: 'Iso 3') do
          click_button "delete"
        end
      }.to change { Rating.count }.from(3).to(2)
    end
  end
end
