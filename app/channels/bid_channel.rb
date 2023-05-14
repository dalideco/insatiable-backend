# Bid channel for nsending notification on bids
class BidChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "Bid channel: player #{current_player.id} subscribed"
    stream_for current_player
  end

  def self.notify_owner(offer)
    broadcast_to(offer.player, {
                   'type' => 'owner',
                   'offer' => offer.as_json
                 })
    Rails.logger.info "Bid channel: Notified offer owner player #{offer.player.id}"
  end

  def self.notify_owner_expired(offer)
    broadcast_to(offer.player, {
                   'type' => 'expired',
                   'offer' => offer.as_json
                 })
    Rails.logger.info "Bid channel: Notified offer owner about expiration player #{offer.player.id}"
  end

  def self.notify_latest_bidder(latest_bidder, offer)
    broadcast_to(latest_bidder, {
                   'type' => 'outbid',
                   'offer' => offer.as_json
                 })
    Rails.logger.info "Bid channel: Notified previous latest bidder player #{latest_bidder.id}"
  end

  def self.notify_bought(buyer, offer)
    broadcast_to(buyer, {
                   'type' => 'bought',
                   'offer' => offer.as_json
                 })
    Rails.logger.info "Bid channel: Notified buyer player #{buyer.id}"
  end

  def self.notify_sold(offer)
    broadcast_to(offer.player, {
                   'type' => 'sold',
                   'offer' => offer.as_json
                 })
    Rails.logger.info "Bid channel: Notified seller player #{offer.player.id}"
  end
end
