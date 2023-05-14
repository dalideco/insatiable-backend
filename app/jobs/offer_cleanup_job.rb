# Job to clean offer after duration has passed
class OfferCleanupJob < ApplicationJob
  queue_as :default

  def perform(id)
    offer = V1::Offer.find_by!(id:)

    # Do something later
    Rails.logger.info("cleaning offer #{offer.id}")

    # stop if offer is expired or sold
    if offer.sold? || offer.expired?
      Rails.logger.info("offer #{offer.id} already sold")
      return
    end

    # offer just expires if no bidding
    unless offer.bid?
      Rails.logger.info("offer #{offer.id} not bidded on, it goes expired")
      ActiveRecord::Base.transaction do
        # updating offer status
        offer.update(status: :expired)
        Rails.logger.info("offer #{offer.id} status set to expired")

        # giving weapon back to it owner
        own = V1::Own.new(
          weapon_id: offer.weapon_id,
          player_id: offer.player_id
        )
        own.save!
        Rails.logger.info "offer #{offer.id}: weapon #{offer.weapon_id} given back to #{offer.player_id}"

        # notifying owner
        BidChannel.notify_owner_expired(offer)
      rescue ActiveRecord::RecordInvalid
        Rails.logger.error("offer #{offer.id}: failed to expire offer")
      end

      return
    end

    # if bidding, transaction is made and offer is sold
    ActiveRecord::Base.transaction do
      # adding coins to seller
      offer.player.update(coins: offer.player.coins + offer.current_bid)
      Rails.logger.info("offer #{offer.id}: coins are moved to #{offer.player.id} ")

      # updating offer status to sold
      offer.update(status: :sold)
      Rails.logger.info("offer #{offer.id} is sold to the latest bidder")

      # sending weapon to latest bidder
      own = V1::Own.new(
        player_id: offer.latest_bidder.id,
        weapon_id: offer.weapon.id
      )
      own.save!
      Rails.logger.info("offer #{offer.id}: weapon ownership is passed to player #{offer.latest_bidder.id}")

      # notifying players
      BidChannel.notify_sold(offer)
      BidChannel.notify_bought(offer.latest_bidder, offer)
    rescue ActiveRecord::RecordInvalid
      Rails.logger.error("offer #{offer.id}: transaction failed")
    end
  end
end
