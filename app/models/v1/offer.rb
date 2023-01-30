module V1
  # offer model
  class Offer < ApplicationRecord
    validates :minimum_bid, presence: true
    validates :buy_now_price, presence: true

    # many to one relationship with player
    belongs_to :player

    # many to one relationship with weapons
    belongs_to :weapon
  end
end
