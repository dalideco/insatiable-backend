# offer model
class Offer < ApplicationRecord
  validates :minimum_bid, presence: true
  validates :buy_now_price, presence: true

  # many to one relationship with player
  belongs_to :player, class_name: 'player'
end
