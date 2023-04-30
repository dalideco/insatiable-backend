module V1
  # offers controller
  class OffersController < ApplicationController
    include OffersControllerDocs

    before_action :authorize_request
    before_action :find_offer, except: %i[create index]
    before_action :remove_from_owned_weapons, only: :create
    before_action :verify_not_expired, only: :bid
    before_action :verify_bid_price, only: :bid

    def index
      render json: Offer.all
    end

    def create
      # creating offer
      @offer = Offer.new(
        player_id: @current_player.id,
        weapon_id: offer_create_params[:weapon_id],
        minimum_bid: offer_create_params[:minimum_bid],
        buy_now_price: offer_create_params[:buy_now_price],
        lifetime: offer_create_params[:lifetime]
      )

      if @offer.save
        lifetime = DurationTransformer.lifetime_from_string(@offer.lifetime)
        Rails.logger.info("runnig cleanup after #{lifetime} ")

        # adding job to clean offer to queue
        OfferCleanupJob.set(wait: lifetime).perform_later(@offer.id)

        # rendering created offer
        render json: { success: true, offer: @offer }
      else
        render status: :bad_request, json: {
          message: @offer.errors.messages
        }
      end
    end

    def show
      render json: @offer
    end

    def bid
      @offer.update(current_bid: bid_params[:bid])

      render json: {
        success: true,
        offer: @offer.as_json
      }
    end

    def update
      @offer.update(offer_update_params)
    end

    private

    def offer_create_params
      params.require(:minimum_bid)
      params.require(:buy_now_price)
      params.require(:weapon_id)
      params.require(:lifetime)
      params.permit(:minimum_bid, :buy_now_price, :weapon_id, :lifetime)
    end

    def offer_update_params
      params.permit(:current_bid)
    end

    def bid_params
      params.require(:bid)
      params.permit(:bid)
    end

    def find_offer
      @offer = Offer.find_by!(id: params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found, json: {
        error: 'Offer not found'
      }
    end

    def remove_from_owned_weapons
      weapon_id = offer_create_params[:weapon_id]

      own = Own.find_by!(weapon_id:, player_id: @current_player.id)

      own.destroy
    rescue ActiveRecord::RecordNotFound
      render status: :not_found, json: {
        success: false,
        error: "Player #{@current_player.id} does not own weapon #{weapon_id}"
      }
    end

    def verify_not_expired
      return unless @offer.expired?

      render status: :expired, json: {
        error: 'The offer is expired'
      }
    end

    def verify_bid_price
      current_bid = @offer.current_bid
      current_bid || current_bid = 0

      return unless bid_params[:bid].to_i <= current_bid || bid_params[:bid].to_i < @offer.minimum_bid

      render status: :conflict, json: {
        error: 'Entered bid price is lower than the minimum'
      }
    end
  end
end
