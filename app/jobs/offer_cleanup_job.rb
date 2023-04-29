# Job to clean offer after duration has passed
class OfferCleanupJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # Do something later
    Rails.logger.info('cleaning offer')
  end
end
