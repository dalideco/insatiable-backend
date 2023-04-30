# Job to clean offer after duration has passed
class OfferCleanupJob < ApplicationJob
  queue_as :default

  def perform(id)
    offer = V1::Offer.find_by!(id:)

    # Do something later
    Rails.logger.info("cleaning offer #{offer.id}")

    # stop if offer is expired or sold
    if offer.sold? || offer.expired?
      Rails.logger.info("offer #{offer.id} already sold or expired")
      return
    end

    # offer just expires if no bidding
    unless offer.bid?
      Rails.logger.info("offer #{offer.id} not bidded on, it goes expired")
      offer.update(status: :expired)
      return
    end

    # if bidding, transaction is made and offer is sold
    ActiveRecord::Base.transaction do
      offer.player.update(coins: offer.player.coins + offer.current_bid)
      Rails.logger.info("offer #{offer.id}: coins are moved to #{offer.player.id} ")

      offer.update(status: :sold)
      Rails.logger.info("offer #{offer.id} is sold to the latest bidder")

      own = V1::Own.new(
        player_id: offer.latest_bidder.id,
        weapon_id: offer.weapon.id
      )
      own.save!
      Rails.logger.info("offer #{offer.id}: weapon ownership is passed to player #{offer.latest_bidder.id}")
    rescue ActiveRecord::RecordInvalid
      Rails.logger.error("offer #{offer.id}: transaction failed")
    end
  end
end
