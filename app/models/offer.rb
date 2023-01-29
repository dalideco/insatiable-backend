# offer model
class Offer < ApplicationRecord
  validates :minimum_bid, presence: true
  validates :buy_now_price, presence: true
end
