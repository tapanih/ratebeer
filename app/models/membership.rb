class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :beer_club
  validates :user, uniqueness: { scope: :beer_club, message: "is already a member of this club" }
end
