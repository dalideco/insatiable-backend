module V1
  # offer model
  class Offer < ApplicationRecord
    validates :minimum_bid, presence: true
    validates :buy_now_price, presence: true

    # many to one relationship with player
    belongs_to :player

    # many to one relationship with weapons
    belongs_to :weapon

    enum :status, { added: 0, bid: 1, sold: 2 }
    enum :lifetime, [
      '1.hour',
      '3.hours',
      '6.hours',
      '12.hours',
      '1.day',
      '3.days'
    ]
  end
end
