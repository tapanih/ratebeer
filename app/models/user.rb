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

  def to_s
    username
  end
end
