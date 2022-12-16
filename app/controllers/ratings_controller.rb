class RatingsController < ApplicationController
  before_action :expire_cache_for_breweries, only: %i[create destroy]

  def index
    if request.format.html?
      expiration_time = 10.minutes
      @recent_ratings = Rating.includes(:user, :beer).recent
      @top_beers = Rails.cache.fetch("beer top 3", expires_in: expiration_time) { Beer.top(3) }
      @top_breweries = Rails.cache.fetch("brewery top 3", expires_in: expiration_time) { Brewery.top(3) }
      @top_styles = Rails.cache.fetch("style top 3", expires_in: expiration_time) { Style.top(3) }
      @top_users = Rails.cache.fetch("user top 3", expires_in: expiration_time) { User.top_by_ratings_count(3) }
    else
      @ratings = Rating.all
    end
  end

  def new
    @rating = Rating.new
    @beers = Beer.includes(:brewery)
  end

  def create
    return redirect_to signin_path, notice: 'You need to sign in first' if current_user.nil?

    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    @rating.user = current_user

    if @rating.save
      redirect_to current_user
    else
      @beers = Beer.includes(:brewery)
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    return redirect_to :root if current_user.nil?

    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path current_user
  end
end
