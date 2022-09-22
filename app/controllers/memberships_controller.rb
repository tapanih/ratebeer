class MembershipsController < ApplicationController
  before_action :ensure_that_signed_in

  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all - current_user.beer_clubs
  end

  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id)
    @membership.user = current_user
    if @membership.save
      notice_text = "Welcome to the club, #{current_user.username}!"
      if request.referrer.include? new_membership_path
        redirect_to current_user, notice: notice_text
      else
        redirect_back(fallback_location: root_path, notice: notice_text)
      end
    else
      @beer_clubs = BeerClub.joins(:memberships).where.not memberships: { user_id: current_user }
      render :new
    end
  end

  def destroy
    membership = Membership.find params[:id]
    membership.destroy if current_user == membership.user
    redirect_to current_user, notice: "Membership in #{membership.beer_club.name} ended"
  end
end
