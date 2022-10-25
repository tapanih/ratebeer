module TopByAverageRating
  extend ActiveSupport::Concern

  def top(count)
    all.sort_by { |x| -x.average_rating }.take(count)
  end
end
