class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    @recent_ratings = Rating.recent
    @top_beers = Beer.top 3
    @top_breweries = Brewery.top 3
    @top_styles = Style.top 3
    @top_users = User.top_by_ratings_count 3
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    return redirect_to signin_path, notice: 'You need to sign in first' if current_user.nil?

    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    @rating.user = current_user

    if @rating.save
      redirect_to current_user
    else
      @beers = Beer.all
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
