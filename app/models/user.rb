class User < ApplicationRecord
  include RatingAverage

  has_secure_password
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true, length: { in: 3..30 }
  validates :password,
            length: { minimum: 4 },
            format: { with: /\d.*[A-Z]|[A-Z].*\d/, message: "must contain a number and an uppercase letter" }

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    style_id = ratings.joins(:beer).group(:style_id).average(:score).max_by { |_, v| v }.first
    Style.find(style_id)
  end

  def favorite_brewery
    return nil if ratings.empty?

    brewery_id = ratings.joins(:beer).group(:brewery_id).average(:score).max_by { |_, v| v }.first
    Brewery.find(brewery_id)
  end

  def to_s
    username
  end
end
