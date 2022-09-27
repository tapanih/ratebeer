require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with too short a password" do
    user = User.create username: "Pekka", password: "Ab1", password_confirmation: "Ab1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password that contains only lowercase letters" do
    user = User.create username: "Pekka", password: "lowercase", password_confirmation: "lowercase"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating({ user: user }, 20)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      create_beer_with_rating({ user: user, style: "Weizen" }, 20)

      expect(user.favorite_style).to eq("Weizen")
    end

    it "is the one with highest average rating" do
      create_beers_with_many_ratings({ user: user, style: "Weizen" }, 1, 5, 10)
      create_beers_with_many_ratings({ user: user, style: "Weizen" }, 15, 20)
      create_beers_with_many_ratings({ user: user, style: "Lager" }, 12, 18)
      create_beers_with_many_ratings({ user: user, style: "Lager" }, 6)
      create_beers_with_many_ratings({ user: user, style: "Porter" }, 11)

      expect(user.favorite_style).to eq("Lager")
    end
  end

  describe "favorite brewery" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      brewery = FactoryBot.create(:brewery)
      create_beer_with_rating({ user: user, brewery: brewery }, 20)

      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the one with highest average rating" do
      brewery1 = FactoryBot.create(:brewery)
      brewery2 = FactoryBot.create(:brewery)
      brewery3 = FactoryBot.create(:brewery)
      create_beers_with_many_ratings({ user: user, brewery: brewery1 }, 1, 5, 10)
      create_beers_with_many_ratings({ user: user, brewery: brewery1 }, 15, 20)
      create_beers_with_many_ratings({ user: user, brewery: brewery2 }, 12, 18)
      create_beers_with_many_ratings({ user: user, brewery: brewery2 }, 6)
      create_beers_with_many_ratings({ user: user, brewery: brewery3 }, 11)

      expect(user.favorite_brewery).to eq(brewery2)
    end
  end
end

def create_beer_with_rating(object, score)
  style = object[:style] || "Lager"
  brewery = object[:brewery] || FactoryBot.create(:brewery)
  beer = FactoryBot.create(:beer, old_style: style, brewery: brewery)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end