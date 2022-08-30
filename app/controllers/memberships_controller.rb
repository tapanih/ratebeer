class MembershipsController < ApplicationController
  def new
    if current_user.nil?
      redirect_to signin_path, notice: "You need to sign in first"
    else
      @membership = Membership.new
      @beer_clubs = BeerClub.all - current_user.beer_clubs
    end
  end

  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id)
    @membership.user = current_user
    if @membership.save
      redirect_to current_user, notice: "Welcome to the club!"
    else
      @beer_clubs = BeerClub.joins(:memberships).where.not memberships: { user_id: current_user }
      render :new
    end
  end
end
