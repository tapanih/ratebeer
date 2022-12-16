module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    ratings_count = ratings.size

    return 0 if ratings_count == 0
    ratings.map(&:score).sum / ratings_count.to_f
  end
end
