module V1
  # offers controller
  class OffersController < ApplicationController
    before_action :authorize_request
    before_action :find_offer, except: %i[create index]
    before_action :check_player_owns_weapon, only: :create

    def index
      render json: Offer.all
    end

    def create
      @offer = Offer.new(
        player_id: @current_player.id,
        weapon_id: offer_create_params[:weapon_id],
        minimum_bid: offer_create_params[:minimum_bid],
        buy_now_price: offer_create_params[:buy_now_price]
      )
      if @offer.save
        render json: @offer
      else
        render status: :bad_request, json: {
          message: @offer.errors.messages
        }
      end
    end

    def show
      render json: @offer
    end

    def update
      @offer.update(offer_update_params)
    end

    private

    def offer_create_params
      params.require(:minimum_bid)
      params.require(:buy_now_price)
      params.require(:weapon_id)
      params.permit(:minimum_bid, :buy_now_price, :weapon_id)
    end

    def offer_update_params
      params.permit(:current_bid)
    end

    def find_offer
      @offer = Offer.find_by!(id: params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: :not_found, json: {
        error: 'Offer not found'
      }
    end

    def check_player_owns_weapon
      weapon_id = offer_create_params[:weapon_id]

      Own.find_by!(weapon_id:, player_id: @current_player.id)
    rescue ActiveRecord::RecordNotFound
      render status: :not_found, json: {
        error: "Player #{@current_player.id} does not own weapon #{weapon_id}"
      }
    end
  end
end
