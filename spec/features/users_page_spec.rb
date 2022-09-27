require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    @user = FactoryBot.create :user
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect {
      click_button('Create User')
    }.to change { User.count }.by(1)
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content "Username and password do not match"
    end
  end

  describe "who has rated beers" do
    it "has his favorite style and brewery shown on his page" do
      brewery = FactoryBot.create :brewery, name: "Koff"
      style = FactoryBot.create :style, name: "Lager"
      beer = FactoryBot.create :beer, style: style, brewery: brewery
      FactoryBot.create :rating, score: 10, beer: beer, user: @user

      visit user_path(@user)
      expect(page).to have_content "Favorite style: Lager"
      expect(page).to have_content "Favorite brewery: Koff"
    end
  end
end
