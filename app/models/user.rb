class User < ApplicationRecord
  include RatingAverage

  has_secure_password
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, -> { where confirmed: true }, dependent: :destroy
  has_many :pending_memberships, -> { where confirmed: false }, class_name: "Membership", dependent: :destroy
  has_many :beer_clubs, through: :memberships
  has_many :pending_beer_clubs, through: :pending_memberships, source: :beer_club

  validates :username, uniqueness: true, length: { in: 3..30 }
  validates :password,
            length: { minimum: 4 },
            format: { with: /\d.*[A-Z]|[A-Z].*\d/, message: "must contain a number and an uppercase letter" }

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first&.beer
  end

  def favorite_style
    favorite(:style)
  end

  def favorite_brewery
    favorite(:brewery)
  end

  def favorite(grouped_by)
    return nil if ratings.empty?

    grouped_ratings = ratings.group_by { |r| r.beer.send(grouped_by) }
    averages = grouped_ratings.map do |group, ratings|
      { group:, score: average_of(ratings) }
    end

    averages.max_by { |r| r[:score] }[:group]
  end

  def average_of(ratings)
    ratings.sum(&:score).to_f / ratings.count
  end

  def self.top_by_ratings_count(count)
    User.includes(:ratings).sort_by { |u| -u.ratings.size }.take(count)
  end

  def to_s
    username
  end
end
