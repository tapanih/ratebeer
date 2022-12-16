class Style < ApplicationRecord
  include RatingAverage
  extend TopByAverageRating

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true

  def to_s
    name
  end
end
