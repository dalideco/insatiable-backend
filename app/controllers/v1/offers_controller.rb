module V1
  # offers controller
  class OffersController < ApplicationController
    include OffersControllerDocs

    before_action :authorize_request
    before_action :find_offer, except: %i[create index]
    before_action :remove_from_owned_weapons, only: :create

    before_action :verify_not_offer_owner, only: %i[bid buy]
    before_action :verify_not_expired, only: %i[bid buy]

    before_action :verify_bid_price, only: :bid
    before_action :deduct_bid_price, only: :bid

    before_action :buy_transaction, only: :buy

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
      @offer.update(current_bid: bid_params[:bid], latest_bidder_id: @current_player.id)

      render json: {
        success: true,
        offer: @offer.as_json
      }
    end

    def buy
      @offer.update(status: :sold)

      own = Own.new(
        player_id: @current_player.id,
        weapon_id: @offer.weapon.id
      )

      own.save!

      render json: {
        success: true,
        weapon: @offer.weapon
      }
    end

    private

    def offer_create_params
      params.require(:minimum_bid)
      params.require(:buy_now_price)
      params.require(:weapon_id)
      params.require(:lifetime)
      params.permit(:minimum_bid, :buy_now_price, :weapon_id, :lifetime)
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
        error: "Player doesn't own weapon"
      }
    end

    def verify_not_offer_owner
      return unless @offer.player_id == @current_player.id

      render status: :conflict, json: {
        success: false,
        error: 'Player cannot bid on his offer'
      }
    end

    def verify_not_expired
      return unless @offer.expired? || @offer.sold?

      render status: :not_acceptable, json: {
        success: false,
        error: 'The offer is expired'
      }
    end

    def verify_bid_price
      current_bid = @offer.current_bid
      current_bid || current_bid = 0

      if bid_params[:bid].to_i >= @offer.buy_now_price
        render status: :conflict, json: {
          success: false,
          error: 'Entered bid price is higher than the buy now price'
        }
      else
        return unless bid_params[:bid].to_i <= current_bid || bid_params[:bid].to_i < @offer.minimum_bid

        render status: :conflict, json: {
          success: false,
          error: 'Entered bid price is lower than the minimum'
        }
      end
    end

    def deduct_bid_price
      if @current_player.coins < bid_params[:bid].to_i
        render status: :payment_required, json: {
          success: false,
          error: 'Insufficient balance'
        }
      else
        @current_player.update(coins: @current_player.coins - bid_params[:bid].to_i)
      end
    end

    def buy_transaction
      if @current_player.coins < @offer.buy_now_price
        render status: :payment_required, json: {
          success: false,
          error: 'Insufficient balance'
        }
        nil
      else
        ActiveRecord::Base.transaction do
          @current_player.update(coins: @current_player.coins - @offer.buy_now_price)
          @offer.player.update(coins: @offer.player.coins + @offer.buy_now_price)

          Rails.logger.info(
            "offer #{@offer.id}: coins transfered from player #{@current_player.id} to #{@offer.player.id}"
          )
        rescue ActiveRecord::RecordInvalid
          Rails.logger.error(
            "offer #{@offer.id}: failed to transfer coins from player #{@current_player.id} to #{@offer.player.id}"
          )
        end
      end
    end
  end
end
