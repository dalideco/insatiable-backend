# Job to clean offer after duration has passed
class OfferCleanupJob < ApplicationJob
  queue_as :default

  def perform(id)
    offer = V1::Offer.find_by!(id:)

    # Do something later
    Rails.logger.info("cleaning offer #{offer.id}")

    return if offer.sold? || offer.expired?

    offer.update(status: :expired) unless offer.bid?

    return unless offer.bid?

    offer.update(status: :sold)
  end
end
