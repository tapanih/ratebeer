class Brewery < ApplicationRecord
  include RatingAverage
  extend TopByAverageRating

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validate :year_of_establisment_cannot_be_in_the_future
  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   only_integer: true }

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def year_of_establisment_cannot_be_in_the_future
    return if year.blank? || year <= Date.current.year

    errors.add(:year, "can't be in the future")
  end

  def to_s
    name
  end
end
