class Style < ApplicationRecord
  has_many :beers, dependent: :destroy

  validates :name, presence: true

  def to_s
    name
  end
end
