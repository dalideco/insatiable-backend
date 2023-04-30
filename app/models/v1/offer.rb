module V1
  # offer model
  class Offer < ApplicationRecord
    validates :minimum_bid, presence: true
    validates :buy_now_price, presence: true

    # many to one relationship with player
    belongs_to :player

    # many to one relationship with weapons
    belongs_to :weapon

    belongs_to :latest_bidder, class_name: 'Player', optional: true

    enum :status, { added: 0, bid: 1, sold: 2, expired: 3 }
    enum :lifetime, [
      '1.hour',
      '3.hours',
      '6.hours',
      '12.hours',
      '1.day',
      '3.days',
      '30.seconds'
    ]

    before_update do |offer|
      offer.status = :bid if current_bid_changed?
    end
  end
end
