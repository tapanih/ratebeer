class MembershipsController < ApplicationController
  before_action :ensure_that_signed_in
  before_action :set_membership, only: %i[confirm destroy]

  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all - current_user.beer_clubs - current_user.pending_beer_clubs
  end

  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id)
    @membership.user = current_user
    @membership.confirmed = false
    if @membership.save
      notice_text = "Your membership is now waiting for approval"
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

  def confirm
    if @membership.nil?
      redirect_to :root, notice: "No such membership application"
      return
    end

    current_users_membership = Membership.find_by user_id: current_user, beer_club_id: @membership.beer_club_id
    if current_users_membership.nil? || !current_users_membership.confirmed
      redirect_to :root, notice: "You are not a member of this club"
      return
    end

    @membership.confirmed = true
    if @membership.save
      redirect_to @membership.beer_club, notice: "Membership application confirmed"
    else
      redirect_to @membership.beer_club, notice: "Membership application could not be confirmed"
    end
  end

  def destroy
    @membership.destroy if current_user == @membership.user
    redirect_to current_user, notice: "Membership in #{@membership.beer_club.name} ended"
  end

  private

  def set_membership
    @membership = Membership.find(params[:id])
  end
end
