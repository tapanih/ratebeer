class BeerClub < ApplicationRecord
  has_many :memberships, -> { where confirmed: true }
  has_many :pending_memberships, -> { where confirmed: false }, class_name: "Membership"
  has_many :members, through: :memberships, source: :user
end
