module TopByAverageRating
  extend ActiveSupport::Concern

  def top(count)
    includes(:ratings).sort_by { |x| -x.average_rating }.take(count)
  end
end
