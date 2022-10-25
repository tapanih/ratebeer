class Style < ApplicationRecord
  extend TopByAverageRating

  has_many :beers, dependent: :destroy

  validates :name, presence: true

  def average_rating
    return 0 if beers.empty?

    beers.map(&:average_rating).sum / beers.count.to_f
  end

  def to_s
    name
  end
end
